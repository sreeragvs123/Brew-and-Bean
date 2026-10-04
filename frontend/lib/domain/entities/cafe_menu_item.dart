import 'package:equatable/equatable.dart';

class CafeMenuItem extends Equatable {
  final int id;
  final String name;
  final String category;
  final double price;
  final bool available;

  const CafeMenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.available,
  });

  @override
  List<Object?> get props => [id, name, category, price, available];
}
