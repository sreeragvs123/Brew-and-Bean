import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class SetAvailability implements UseCase<Unit, SetAvailabilityParams> {
  final CafeRepository _repository;
  SetAvailability(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SetAvailabilityParams params) {
    return _repository.setAvailability(params.itemId, params.available);
  }
}

class SetAvailabilityParams extends Equatable {
  final int itemId;
  final bool available;

  const SetAvailabilityParams({required this.itemId, required this.available});

  @override
  List<Object?> get props => [itemId, available];
}
