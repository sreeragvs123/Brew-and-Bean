import 'dart:convert';

import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/sse_client.dart';
import 'package:frontend/data/models/menu_item_model.dart';
import 'package:frontend/data/models/order_model.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/entities/live_event.dart';

abstract class CafeRemoteDataSource {
  Future<List<MenuItemModel>> getMenu();
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> placeOrder(String customerName, Map<int, int> cart);
  Future<void> updateOrderStatus(int orderId, OrderStatus status);
  Future<void> setAvailability(int itemId, bool available);
  Future<void> postAnnouncement(String message);
  Stream<LiveEvent> watchLiveEvents();
}

class CafeRemoteDataSourceImpl implements CafeRemoteDataSource {
  static const _reconnectDelay = Duration(seconds: 3);

  final ApiClient _api;
  final SseClient _sse;

  CafeRemoteDataSourceImpl({required ApiClient api, required SseClient sse})
      : _api = api,
        _sse = sse;

  @override
  Future<List<MenuItemModel>> getMenu() async {
    final json = await _api.get('/menu') as List;
    return json.map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final json = await _api.get('/orders') as List;
    return json.map((order) => OrderModel.fromJson(order as Map<String, dynamic>)).toList();
  }

  @override
  Future<OrderModel> placeOrder(String customerName, Map<int, int> cart) async {
    final json = await _api.post('/orders', body: {
      'customerName': customerName,
      'items': [
        for (final entry in cart.entries) {'menuItemId': entry.key, 'quantity': entry.value},
      ],
    });
    return OrderModel.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<void> updateOrderStatus(int orderId, OrderStatus status) {
    return _api.patch('/orders/$orderId/status', query: {'status': status.apiValue});
  }

  @override
  Future<void> setAvailability(int itemId, bool available) {
    return _api.patch('/menu/$itemId/availability', query: {'available': '$available'});
  }

  @override
  Future<void> postAnnouncement(String message) {
    return _api.post('/announcements', body: {'message': message});
  }

  /// Opens the live stream and reopens it whenever it drops.
  @override
  Stream<LiveEvent> watchLiveEvents() async* {
    while (true) {
      try {
        await for (final message in _sse.connect('${_api.baseUrl}/stream')) {
          final event = _toLiveEvent(message);
          if (event != null) yield event;
        }
      } catch (_) {
        // connection failed or dropped: report it and try again below
      }
      yield const StreamDisconnected();
      await Future.delayed(_reconnectDelay);
    }
  }

  LiveEvent? _toLiveEvent(SseMessage message) {
    final data = jsonDecode(message.data) as Map<String, dynamic>;

    return switch (message.event) {
      'connected' => const StreamConnected(),
      'menu' => MenuUpdated(MenuItemModel.fromJson(data)),
      'order' => OrderUpdated(OrderModel.fromJson(data)),
      'announcement' => AnnouncementReceived(data['message'] as String),
      _ => null,
    };
  }
}