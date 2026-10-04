import 'package:frontend/core/constants/api_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';


import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/sse_client.dart';
import 'package:frontend/domain/repository/cafe_repository.dart';
import 'package:frontend/domain/usecases/get_menu.dart';
import 'package:frontend/domain/usecases/get_orders.dart';
import 'package:frontend/domain/usecases/place_order.dart';
import 'package:frontend/domain/usecases/post_announcement.dart';
import 'package:frontend/domain/usecases/set_availability.dart';
import 'package:frontend/domain/usecases/update_order_status.dart';
import 'package:frontend/domain/usecases/watch_live_events.dart';
import 'package:frontend/presentation/bloc/cafe_bloc.dart';
import 'package:frontend/data/datasources/cafe_remote_data_source.dart';
import 'package:frontend/data/repository_impl/cafe_repository_impl.dart';
final sl = GetIt.instance;

void initDependencies() {
  // core
  sl.registerLazySingleton(() => Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      )));
  sl.registerLazySingleton(() => ApiClient(dio: sl()));
  
  sl.registerLazySingleton(() => SseClient());

  // data
  sl.registerLazySingleton<CafeRemoteDataSource>(
    () => CafeRemoteDataSourceImpl(api: sl(), sse: sl()),
  );
  sl.registerLazySingleton<CafeRepository>(() => CafeRepositoryImpl(sl()));

  // use cases
  sl.registerLazySingleton(() => GetMenu(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatus(sl()));
  sl.registerLazySingleton(() => SetAvailability(sl()));
  sl.registerLazySingleton(() => PostAnnouncement(sl()));
  sl.registerLazySingleton(() => WatchLiveEvents(sl()));

  // presentation
  sl.registerFactory(() => CafeBloc(
        getMenu: sl(),
        getOrders: sl(),
        placeOrder: sl(),
        updateOrderStatus: sl(),
        setAvailability: sl(),
        postAnnouncement: sl(),
        watchLiveEvents: sl(),
      ));
}
