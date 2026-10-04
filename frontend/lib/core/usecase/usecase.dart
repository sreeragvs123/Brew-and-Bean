import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/core/error/failures.dart';

/// A one-shot action. Returns either a [Failure] or the result.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// A use case that stays open and keeps emitting values (the live server updates).
abstract class StreamUseCase<Type> {
  Stream<Type> call();
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
