import 'package:dartz/dartz.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/cafe_menu_item.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class GetMenu implements UseCase<List<CafeMenuItem>, NoParams> {
  final CafeRepository _repository;
  GetMenu(this._repository);

  @override
  Future<Either<Failure, List<CafeMenuItem>>> call(NoParams params) => _repository.getMenu();
}
