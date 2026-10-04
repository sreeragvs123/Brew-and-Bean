
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/cafe_menu_item.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/entities/live_event.dart';
import 'package:frontend/domain/usecases/get_menu.dart';
import 'package:frontend/domain/usecases/get_orders.dart';
import 'package:frontend/domain/usecases/place_order.dart';
import 'package:frontend/domain/usecases/post_announcement.dart';
import 'package:frontend/domain/usecases/set_availability.dart';
import 'package:frontend/domain/usecases/update_order_status.dart';
import 'package:frontend/domain/usecases/watch_live_events.dart';

part 'cafe_event.dart';
part 'cafe_state.dart';

class CafeBloc extends Bloc<CafeEvent, CafeState> {
  final GetMenu getMenu;
  final GetOrders getOrders;
  final PlaceOrder placeOrder;
  final UpdateOrderStatus updateOrderStatus;
  final SetAvailability setAvailability;
  final PostAnnouncement postAnnouncement;
  final WatchLiveEvents watchLiveEvents;

  CafeBloc({
    required this.getMenu,
    required this.getOrders,
    required this.placeOrder,
    required this.updateOrderStatus,
    required this.setAvailability,
    required this.postAnnouncement,
    required this.watchLiveEvents,
  }) : super(const CafeState()) {
    on<CafeStarted>(_onStarted);
    on<CafeRefreshRequested>(_onRefreshRequested);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<OrderSubmitted>(_onOrderSubmitted);
    on<OrderStatusAdvanced>(_onOrderStatusAdvanced);
    on<AvailabilityToggled>(_onAvailabilityToggled);
    on<AnnouncementPosted>(_onAnnouncementPosted);
  }

  // ---------------------------------------------------------------------------
  // Live updates from the server
  // ---------------------------------------------------------------------------

  Future<void> _onStarted(CafeStarted event, Emitter<CafeState> emit) {
    return emit.forEach<LiveEvent>(watchLiveEvents(), onData: _onLiveEvent);
  }

  CafeState _onLiveEvent(LiveEvent event) {
    return switch (event) {
      StreamConnected() => _onStreamConnected(),
      StreamDisconnected() => state.copyWith(connected: false),
      MenuUpdated(:final item) => _withUpdatedMenuItem(item),
      OrderUpdated(:final order) => state.copyWith(orders: _upsertOrder(state.orders, order)),
      AnnouncementReceived(:final message) => state.copyWith(announcement: message),
    };
  }

  CafeState _onStreamConnected() {
    // Events may have been missed while offline, so load everything again.
    add(const CafeRefreshRequested());
    return state.copyWith(connected: true);
  }

  CafeState _withUpdatedMenuItem(CafeMenuItem updated) {
    final menu = [for (final item in state.menu) item.id == updated.id ? updated : item];

    // An item that just sold out must disappear from the cart.
    final cart = Map<int, int>.of(state.cart);
    if (!updated.available) cart.remove(updated.id);

    return state.copyWith(menu: menu, cart: cart);
  }

  List<CafeOrder> _upsertOrder(List<CafeOrder> orders, CafeOrder order) {
    final alreadyListed = orders.any((o) => o.id == order.id);
    if (alreadyListed) {
      return [for (final o in orders) o.id == order.id ? order : o];
    }
    return [order, ...orders];
  }

  Future<void> _onRefreshRequested(CafeRefreshRequested event, Emitter<CafeState> emit) async {
    final menuResult = await getMenu(const NoParams());
    final ordersResult = await getOrders(const NoParams());

    if (menuResult.isLeft() || ordersResult.isLeft()) {
      emit(state.copyWith(error: 'Could not load the latest cafe data'));
      return;
    }

    emit(state.copyWith(
      loading: false,
      menu: menuResult.getOrElse(() => []),
      orders: ordersResult.getOrElse(() => []),
    ));
  }

  // ---------------------------------------------------------------------------
  // Customer actions
  // ---------------------------------------------------------------------------

  void _onCartItemAdded(CartItemAdded event, Emitter<CafeState> emit) {
    final item = state.menu.where((m) => m.id == event.itemId);
    if (item.isEmpty || !item.first.available) return;

    final cart = Map<int, int>.of(state.cart);
    cart[event.itemId] = (cart[event.itemId] ?? 0) + 1;
    emit(state.copyWith(cart: cart));
  }

  void _onCartItemRemoved(CartItemRemoved event, Emitter<CafeState> emit) {
    final cart = Map<int, int>.of(state.cart);
    final newQuantity = (cart[event.itemId] ?? 0) - 1;

    if (newQuantity <= 0) {
      cart.remove(event.itemId);
    } else {
      cart[event.itemId] = newQuantity;
    }
    emit(state.copyWith(cart: cart));
  }

  Future<void> _onOrderSubmitted(OrderSubmitted event, Emitter<CafeState> emit) async {
    if (state.cart.isEmpty) return;
    emit(state.copyWith(placingOrder: true));

    final result = await placeOrder(
      PlaceOrderParams(customerName: event.customerName, cart: state.cart),
    );

    result.fold(
      (failure) => emit(state.copyWith(placingOrder: false, error: failure.message)),
      (order) => emit(state.copyWith(
        placingOrder: false,
        cart: const {},
        // The server also pushes this order; matching ids keep it from appearing twice.
        orders: _upsertOrder(state.orders, order),
      )),
    );
  }

  // ---------------------------------------------------------------------------
  // Barista actions (the screen updates when the server pushes the result)
  // ---------------------------------------------------------------------------

  Future<void> _onOrderStatusAdvanced(OrderStatusAdvanced event, Emitter<CafeState> emit) async {
    final nextStatus = event.order.status.next;
    if (nextStatus == null) return;

    final result = await updateOrderStatus(
      UpdateOrderStatusParams(orderId: event.order.id, status: nextStatus),
    );
    _emitErrorIfFailed(result, emit);
  }

  Future<void> _onAvailabilityToggled(AvailabilityToggled event, Emitter<CafeState> emit) async {
    final result = await setAvailability(
      SetAvailabilityParams(itemId: event.item.id, available: !event.item.available),
    );
    _emitErrorIfFailed(result, emit);
  }

  Future<void> _onAnnouncementPosted(AnnouncementPosted event, Emitter<CafeState> emit) async {
    final result = await postAnnouncement(event.message);
    _emitErrorIfFailed(result, emit);
  }

  void _emitErrorIfFailed(Either<Failure, Unit> result, Emitter<CafeState> emit) {
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {},
    );
  }
}
