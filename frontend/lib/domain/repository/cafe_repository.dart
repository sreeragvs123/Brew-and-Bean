

import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/cafe_menu_item.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/entities/live_event.dart';

abstract class CafeRepository {
  Future<Either<Failure, List<CafeMenuItem>>> getMenu();
  Future<Either<Failure, List<CafeOrder>>> getOrders();
  Future<Either<Failure, CafeOrder>> placeOrder(String customerName, Map<int, int> cart);
  Future<Either<Failure, Unit>> updateOrderStatus(int orderId, OrderStatus status);
  Future<Either<Failure, Unit>> setAvailability(int itemId, bool available);
  Future<Either<Failure, Unit>> postAnnouncement(String message);

  /// Live updates pushed by the server. Reconnects automatically.
  Stream<LiveEvent> watchLiveEvents();
}
