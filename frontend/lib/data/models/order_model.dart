import 'package:frontend/domain/entities/cafe_order.dart';

class OrderModel extends CafeOrder {
  const OrderModel({
    required super.id,
    required super.customerName,
    required super.items,
    required super.total,
    required super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final lines = json['items'] as List;

    return OrderModel(
      id: (json['id'] as num).toInt(),
      customerName: json['customerName'] as String,
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.fromApi(json['status'] as String),
      items: lines.map((line) => _lineFromJson(line as Map<String, dynamic>)).toList(),
    );
  }

  static OrderLine _lineFromJson(Map<String, dynamic> json) {
    return OrderLine(
      menuItemId: (json['menuItemId'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );
  }
}