import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class PlaceOrder implements UseCase<CafeOrder, PlaceOrderParams> {
  final CafeRepository _repository;
  PlaceOrder(this._repository);

  @override
  Future<Either<Failure, CafeOrder>> call(PlaceOrderParams params) {
    return _repository.placeOrder(params.customerName, params.cart);
  }
}

class PlaceOrderParams extends Equatable {
  final String customerName;
  final Map<int, int> cart; // menuItemId -> quantity

  const PlaceOrderParams({required this.customerName, required this.cart});

  @override
  List<Object?> get props => [customerName, cart];
}
