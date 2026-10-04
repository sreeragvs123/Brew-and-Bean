import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/live_event.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class WatchLiveEvents implements StreamUseCase<LiveEvent> {
  final CafeRepository _repository;
  WatchLiveEvents(this._repository);

  @override
  Stream<LiveEvent> call() => _repository.watchLiveEvents();
}
