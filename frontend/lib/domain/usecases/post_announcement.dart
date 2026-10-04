import 'package:dartz/dartz.dart';

import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class PostAnnouncement implements UseCase<Unit, String> {
  final CafeRepository _repository;
  PostAnnouncement(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String message) => _repository.postAnnouncement(message);
}
