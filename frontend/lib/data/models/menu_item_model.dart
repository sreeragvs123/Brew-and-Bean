import 'package:frontend/domain/entities/cafe_menu_item.dart';

class MenuItemModel extends CafeMenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.available,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      available: json['available'] as bool,
    );
  }
}