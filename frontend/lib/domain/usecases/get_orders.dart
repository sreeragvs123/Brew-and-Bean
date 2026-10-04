import 'package:dartz/dartz.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class GetOrders implements UseCase<List<CafeOrder>, NoParams> {
  final CafeRepository _repository;
  GetOrders(this._repository);

  @override
  Future<Either<Failure, List<CafeOrder>>> call(NoParams params) => _repository.getOrders();
}
