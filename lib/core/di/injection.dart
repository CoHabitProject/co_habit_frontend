import 'dart:io';

import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/data/repositories/auth_repository_impl.dart';
import 'package:co_habit_frontend/data/repositories/foyer_repository_impl.dart';
import 'package:co_habit_frontend/data/repositories/stock_repository_impl.dart';
import 'package:co_habit_frontend/data/repositories/tache_repository_impl.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/auth_remote_datasource.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/foyer_remote_datasource.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/stock_remote_datasource.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/tache_remote_datasource.dart';
import 'package:co_habit_frontend/data/services/interceptors/token_interceptor.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:co_habit_frontend/domain/repositories/foyer_repository.dart';
import 'package:co_habit_frontend/domain/repositories/stock_repository.dart';
import 'package:co_habit_frontend/domain/repositories/tache_repository.dart';
import 'package:co_habit_frontend/domain/usecases/auth/login_usecase.dart';
import 'package:co_habit_frontend/domain/usecases/auth/signup_usecase.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  // Dépendances externes
  _registerExternalDependencies();

  // Data sources
  _registerDataSources();

  // Repositories
  _registerRepositories();

  // Use cases
  _registerUseCases();
}

void _registerExternalDependencies() {
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: AppConstants.defaultHeaders,
      connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
    ));

    dio.interceptors.add(TokenInterceptor(getIt<FlutterSecureStorage>()));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
      logPrint: (object) => stderr.write('[DIO] $object'),
    ));

    return dio;
  });

  getIt.registerLazySingleton(() => FloatingNavbarController());
}

void _registerDataSources() {
  // Auth
  getIt.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasource(getIt<Dio>(), getIt<FlutterSecureStorage>()),
  );

  // Foyer
  getIt.registerLazySingleton<FoyerRemoteDatasource>(
      () => FoyerRemoteDataSourceImpl(dio: getIt()));

  // Tâche remote datasource
  getIt.registerLazySingleton<TacheRemoteDatasource>(
      () => TacheRemoteDatasourceImpl(dio: getIt()));

  // Stock remote datasource
  getIt.registerLazySingleton<StockRemoteDatasource>(
      () => StockRemoteDatasourceImpl(dio: getIt()));
}

void _registerRepositories() {
  // Foyer repository
  getIt.registerLazySingleton<FoyerRepository>(
      () => FoyerRepositoryImpl(remoteDataSource: getIt()));
  // Auth
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()),
  );

  // Foyer
  // getIt.registerLazySingleton<CreerFoyerRepository>(
  //       () => CreerFoyerRepositoryImpl(remoteDataSource: getIt()),
  // );

  // Tâche repository
  getIt.registerLazySingleton<TacheRepository>(
      () => TacheRepositoryImpl(tacheRemoteDatasource: getIt()));

  // Stock repository
  getIt.registerLazySingleton<StockRepository>(
      () => StockRepositoryImpl(stockRemoteDatasource: getIt()));
}

void _registerUseCases() {
  // Auth
  getIt.registerFactory<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<SignupUseCase>(
      () => SignupUseCase(getIt<AuthRepository>()),
  );

  // Foyer
  getIt.registerLazySingleton(() => CreerFoyerUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFoyerByCodeUc(foyerRepository: getIt()));

  // Tâche use cases
  getIt.registerLazySingleton(() => GetLastCreatedTachesUc(getIt()));

  // Stock use cases
  getIt.registerLazySingleton(() => GetLowestStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => GetAllStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => CreerStockUc(stockRepository: getIt()));
}

void resetDependencies() {
  getIt.reset();
}
