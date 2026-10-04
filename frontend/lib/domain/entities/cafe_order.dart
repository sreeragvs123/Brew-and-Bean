import 'package:equatable/equatable.dart';

enum OrderStatus {
  placed,
  preparing,
  ready,
  completed;

  /// The value the server uses, e.g. "PREPARING".
  String get apiValue => name.toUpperCase();

  static OrderStatus fromApi(String value) {
    return OrderStatus.values.firstWhere((status) => status.apiValue == value);
  }

  /// The status that comes after this one, or null if this is the last.
  OrderStatus? get next {
    return index + 1 < OrderStatus.values.length ? OrderStatus.values[index + 1] : null;
  }

  String get label => name[0].toUpperCase() + name.substring(1);
}

class OrderLine extends Equatable {
  final int menuItemId;
  final String name;
  final int quantity;
  final double price;

  const OrderLine({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [menuItemId, name, quantity, price];
}

class CafeOrder extends Equatable {
  final int id;
  final String customerName;
  final List<OrderLine> items;
  final double total;
  final OrderStatus status;

  const CafeOrder({
    required this.id,
    required this.customerName,
    required this.items,
    required this.total,
    required this.status,
  });

  @override
  List<Object?> get props => [id, customerName, items, total, status];
}
