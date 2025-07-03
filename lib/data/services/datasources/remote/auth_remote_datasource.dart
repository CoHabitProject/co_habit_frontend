import 'dart:convert';
import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDatasource {
  Future<UserCredentials?> login(LoginRequest request);
  Future<UserCredentials?> refreshToken(String oldRefreshToken);
  Future<bool> signup(RegisterData data);
  Future<UtilisateurModel?> fetchCurrentUser(String accessToken);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;
  final LogService log;

  AuthRemoteDatasourceImpl({
    required this.dio,
    required this.log,
  });

  @override
  Future<UserCredentials?> login(LoginRequest request) async {
    try {
      log.debug('[Datasource] login → payload: ${request.toJson()}');

      final response = await dio.post(
        AppConstants.login,
        data: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 && response.data != null) {
        final tokens = response.data;
        final accessToken = tokens['access_token'];
        final refreshToken = tokens['refresh_token'];
        final expiresIn = tokens['expires_in'];

        final user = await fetchCurrentUser(accessToken);
        if (user == null) return null;

        final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));

        return UserCredentials(
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenExpiry: expiryDate,
          user: user,
        );
      }
    } catch (e, stack) {
      log.error('[Datasource] login → $e', stackTrace: stack);
    }
    return null;
  }

  @override
  Future<UserCredentials?> refreshToken(String oldRefreshToken) async {
    try {
      log.debug('[Datasource] refreshToken → old: $oldRefreshToken');

      final dioNoInterceptor = Dio(BaseOptions(
        baseUrl: AppConstants.baseUrl,
        headers: AppConstants.defaultHeaders,
      ));

      final response = await dioNoInterceptor.post(
        AppConstants.refresh,
        data: jsonEncode({'refreshToken': oldRefreshToken}),
      );

      log.debug('[Datasource] refreshToken → status: ${response.statusCode}');
      log.debug(
          '[Datasource] refreshToken → response: ${response.data.access_token}');

      if (response.statusCode == 200 && response.data != null) {
        final tokens = response.data;
        final accessToken = tokens['access_token'];
        final refreshToken = tokens['refresh_token'];
        final expiresIn = tokens['expires_in'];

        final user = await fetchCurrentUser(accessToken);
        if (user == null) return null;

        final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));

        return UserCredentials(
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenExpiry: expiryDate,
          user: user,
        );
      }
    } catch (e, stack) {
      log.error('[Datasource] refreshToken → $e', stackTrace: stack);
    }
    return null;
  }

  @override
  Future<UtilisateurModel?> fetchCurrentUser(String accessToken) async {
    try {
      final response = await dio.get(
        AppConstants.userStatus,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UtilisateurModel.fromJson(response.data);
      }
    } catch (e, stack) {
      log.error('[Datasource] fetchCurrentUser → $e', stackTrace: stack);
    }
    return null;
  }

  @override
  Future<bool> signup(RegisterData data) async {
    try {
      log.debug('[Datasource] signup → payload: ${data.toJson()}');

      final response = await dio.post(
        AppConstants.register,
        data: jsonEncode(data.toJson()),
      );

      log.debug('[Datasource] signup → status: ${response.statusCode}');
      return response.statusCode == 201;
    } catch (e, stack) {
      log.error('[Datasource] signup → $e', stackTrace: stack);
    }
    return false;
  }
}
