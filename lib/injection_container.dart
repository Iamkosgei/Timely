import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/prime_number/data/datasources/number_local_data_source.dart';
import 'features/prime_number/data/datasources/number_remote_data_source.dart';
import 'features/prime_number/data/repositories/number_repository_impl.dart';
import 'features/prime_number/domain/repositories/number_repository.dart';
import 'features/prime_number/domain/usecases/check_prime.dart';
import 'features/prime_number/domain/usecases/get_random_number.dart';
import 'features/prime_number/presentation/cubits/number_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependencies
Future<void> init() async {
  //! Features - Prime Number
  // Cubit
  sl.registerFactory(
    () => NumberCubit(
      getRandomNumber: sl(),
      checkPrime: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRandomNumber(repository: sl()));
  sl.registerLazySingleton(() => CheckPrime());

  // Repository
  sl.registerLazySingleton<NumberRepository>(
    () => NumberRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NumberRemoteDataSource>(
    () => NumberRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<NumberLocalDataSource>(
    () => NumberLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  // Dio
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    return dio;
  });

  // Internet connection checker
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
