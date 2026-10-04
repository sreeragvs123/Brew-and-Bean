import 'package:dartz/dartz.dart';

import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/datasources/cafe_remote_data_source.dart';
import 'package:frontend/domain/entities/cafe_menu_item.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/domain/entities/live_event.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';

class CafeRepositoryImpl implements CafeRepository {
  final CafeRemoteDataSource _remote;
  CafeRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<CafeMenuItem>>> getMenu() => _guard(_remote.getMenu);

  @override
  Future<Either<Failure, List<CafeOrder>>> getOrders() => _guard(_remote.getOrders);

  @override
  Future<Either<Failure, CafeOrder>> placeOrder(String customerName, Map<int, int> cart) {
    return _guard(() => _remote.placeOrder(customerName, cart));
  }

  @override
  Future<Either<Failure, Unit>> updateOrderStatus(int orderId, OrderStatus status) {
    return _guardUnit(() => _remote.updateOrderStatus(orderId, status));
  }

  @override
  Future<Either<Failure, Unit>> setAvailability(int itemId, bool available) {
    return _guardUnit(() => _remote.setAvailability(itemId, available));
  }

  @override
  Future<Either<Failure, Unit>> postAnnouncement(String message) {
    return _guardUnit(() => _remote.postAnnouncement(message));
  }

  @override
  Stream<LiveEvent> watchLiveEvents() => _remote.watchLiveEvents();

  /// Runs a data source call and turns any exception into a [Failure].
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  Future<Either<Failure, Unit>> _guardUnit(Future<void> Function() call) {
    return _guard(() async {
      await call();
      return unit;
    });
  }
}