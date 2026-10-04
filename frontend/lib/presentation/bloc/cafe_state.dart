part of 'cafe_bloc.dart';

class CafeState extends Equatable {
  /// True until the first menu + orders load succeeds.
  final bool loading;

  /// Whether the live connection to the server is open.
  final bool connected;

  final bool placingOrder;
  final List<CafeMenuItem> menu;
  final List<CafeOrder> orders;
  final Map<int, int> cart; // menuItemId -> quantity
  final String? announcement;

  /// One-shot message for a snackbar. It is cleared by the next state change.
  final String? error;

  const CafeState({
    this.loading = true,
    this.connected = false,
    this.placingOrder = false,
    this.menu = const [],
    this.orders = const [],
    this.cart = const {},
    this.announcement,
    this.error,
  });

  double get cartTotal {
    var total = 0.0;
    for (final entry in cart.entries) {
      final item = menu.where((m) => m.id == entry.key);
      if (item.isNotEmpty) total += item.first.price * entry.value;
    }
    return total;
  }

  CafeState copyWith({
    bool? loading,
    bool? connected,
    bool? placingOrder,
    List<CafeMenuItem>? menu,
    List<CafeOrder>? orders,
    Map<int, int>? cart,
    String? announcement,
    String? error,
  }) {
    return CafeState(
      loading: loading ?? this.loading,
      connected: connected ?? this.connected,
      placingOrder: placingOrder ?? this.placingOrder,
      menu: menu ?? this.menu,
      orders: orders ?? this.orders,
      cart: cart ?? this.cart,
      announcement: announcement ?? this.announcement,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [loading, connected, placingOrder, menu, orders, cart, announcement, error];
}
