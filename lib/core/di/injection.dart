import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/data/repositories/creer_foyer_repository_impl.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/auth_remote_datasource.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/foyer_remote_datasource.dart';
import 'package:co_habit_frontend/domain/repositories/creer_foyer_repository.dart'; // Add this import
import 'package:co_habit_frontend/domain/usecases/foyer/creer_foyer_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  // External dependencies
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: AppConstants.defaultHeaders,
      connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
    ));

    return dio;
  });

  // === Auth ===
  getIt.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(getIt<Dio>(),const FlutterSecureStorage()),
  );

  // Data sources
  getIt.registerLazySingleton<FoyerRemoteDatasource>(
    () => FoyerRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<CreerFoyerRepository>(
    () => CreerFoyerRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => CreerFoyerUseCase(getIt()));
}

// Optional: Add a method to reset dependencies (useful for testing)
void resetDependencies() {
  getIt.reset();
}
