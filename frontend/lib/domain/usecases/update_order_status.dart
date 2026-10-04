import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class UpdateOrderStatus implements UseCase<Unit, UpdateOrderStatusParams> {
  final CafeRepository _repository;
  UpdateOrderStatus(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateOrderStatusParams params) {
    return _repository.updateOrderStatus(params.orderId, params.status);
  }
}

class UpdateOrderStatusParams extends Equatable {
  final int orderId;
  final OrderStatus status;

  const UpdateOrderStatusParams({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}
