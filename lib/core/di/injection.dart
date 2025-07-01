import 'dart:io';

import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/services/iml/log_service_impl.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/repositories/repositories_impl.dart';
import 'package:co_habit_frontend/data/services/datasources/datasources.dart';
import 'package:co_habit_frontend/data/services/interceptors/token_interceptor.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';
import 'package:co_habit_frontend/domain/usecases/stock/creer_stock_item_uc.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  _registerExternalServices();
  _registerServices();
  _registerDataSources();
  _registerRepositories();
  _registerProviders();
  _registerUseCases();

  // 👉 Ajout de l’intercepteur après enregistrement complet
  getIt<Dio>().interceptors.add(getIt<TokenInterceptor>());
}

void _registerExternalServices() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

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
}

void _registerServices() {
  getIt.registerLazySingleton(() => TokenService());
  getIt.registerLazySingleton(() => CurrentUserService());
  getIt.registerLazySingleton(() => FloatingNavbarController());
  getIt.registerLazySingleton<LogService>(() => LogServiceImpl());
}

void _registerDataSources() {
  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(dio: getIt(), log: getIt<LogService>()),
  );

  getIt.registerLazySingleton<FoyerRemoteDatasource>(
    () => FoyerRemoteDataSourceImpl(dio: getIt(), log: getIt<LogService>()),
  );

  getIt.registerLazySingleton<TacheRemoteDatasource>(
    () => TacheRemoteDatasourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<StockRemoteDatasource>(
    () => StockRemoteDatasourceImpl(dio: getIt()),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      datasource: getIt<AuthRemoteDatasource>(),
      tokenService: getIt<TokenService>(),
      currentUserService: getIt<CurrentUserService>(),
      log: getIt<LogService>()));

  getIt.registerLazySingleton<FoyerRepository>(
    () => FoyerRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<TacheRepository>(
    () => TacheRepositoryImpl(tacheRemoteDatasource: getIt()),
  );

  getIt.registerLazySingleton<StockRepository>(
    () => StockRepositoryImpl(stockRemoteDatasource: getIt()),
  );
}

void _registerProviders() {
  getIt.registerLazySingleton(() => AuthProvider(
        authRepository: getIt<AuthRepository>(),
        tokenService: getIt<TokenService>(),
        currentUserService: getIt<CurrentUserService>(),
      ));

  getIt.registerLazySingleton(() => TokenInterceptor(
      tokenService: getIt<TokenService>(),
      authRepository: getIt<AuthRepository>(),
      log: getIt<LogService>()));
}

void _registerUseCases() {
  getIt.registerFactory(() => SignupUseCase(getIt<AuthRepository>()));

  // Foyer
  getIt.registerLazySingleton(() => CreerFoyerUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFoyerByCodeUc(foyerRepository: getIt()));

  // Tâches
  getIt.registerLazySingleton(() => GetLastCreatedTachesUc(getIt()));

  // Stock
  getIt.registerLazySingleton(() => GetLowestStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => GetAllStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => CreerStockUc(stockRepository: getIt()));
  getIt.registerLazySingleton(() => CreerStockItemUc(stockRepository: getIt()));
}

void resetDependencies() {
  getIt.reset();
}
