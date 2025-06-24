import 'dart:io';

import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/data/repositories/repositories_impl.dart';
import 'package:co_habit_frontend/data/services/datasources/datasources.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  // Dépendences externes
  _registerExternalDependencies();

  // Data sources
  _registerDataSources();

  // Repositories
  _registerRepositories();

  // Use cases
  _registerUseCases();
}

void _registerExternalDependencies() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: AppConstants.defaultHeaders,
      connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
    ));

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
  // Foyer remote datasouce
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

  // Tâche repository
  getIt.registerLazySingleton<TacheRepository>(
      () => TacheRepositoryImpl(tacheRemoteDatasource: getIt()));

  // Stock repository
  getIt.registerLazySingleton<StockRepository>(
      () => StockRepositoryImpl(stockRemoteDatasource: getIt()));
}

void _registerUseCases() {
  // Foyer use cases
  getIt.registerLazySingleton(() => CreerFoyerUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFoyerByCodeUc(foyerRepository: getIt()));

  // Tâche use cases
  getIt.registerLazySingleton(() => GetLastCreatedTachesUc(getIt()));

  // Stock use cases
  getIt.registerLazySingleton(() => GetLowestStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => GetAllStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => CreerStockUc(stockRepository: getIt()));
}
