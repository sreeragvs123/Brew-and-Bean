import 'package:equatable/equatable.dart';

/// What the domain and presentation layers see when something goes wrong.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Cannot reach the cafe. Check your connection.');
}
