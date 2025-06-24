import 'dart:convert';
import 'dart:io';

import 'package:co_habit_frontend/config/constants/app_constants.dart';
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

  AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<UserCredentials?> login(LoginRequest request) async {
    try {
      final response = await dio.post(AppConstants.login,
          data: jsonEncode(request.toJson()));

      print('[Datasource] login → status: ${response.statusCode}');
      print('[Datasource] login → response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final tokens = response.data;

        final accessToken = tokens['access_token'];
        final refreshToken = tokens['refresh_token'];
        final expiresIn = tokens['expires_in'];

        final user = await fetchCurrentUser(accessToken);
        print('[Datasource] fetchCurrentUser → $user');
        if (user == null) return null;

        final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));

        return UserCredentials(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenExpiry: expiryDate,
            user: user);
      }
    } catch (e) {
      stderr.write('API error on login: $e');
    }
    return null;
  }

  @override
  Future<UserCredentials?> refreshToken(String oldRefreshToken) async {
    try {
      final response = await dio.post(AppConstants.refresh,
          data: jsonEncode({'refreshToken': oldRefreshToken}));

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
    } catch (e) {
      stderr.write('API error on refreshToken: $e');
    }
    return null;
  }

  @override
  Future<UtilisateurModel?> fetchCurrentUser(String accessToken) async {
    try {
      final response = await dio.get(
        AppConstants.userStatus,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      print('[Datasource] fetchCurrentUser → status: ${response.statusCode}');
      print('[Datasource] fetchCurrentUser → body: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return UtilisateurModel.fromJson(response.data);
      }
    } catch (e) {
      stderr.write('API error on fetchCurrentUser: $e');
    }
    return null;
  }

  @override
  Future<bool> signup(RegisterData data) async {
    try {
      final response = await dio.post(
        AppConstants.register,
        data: jsonEncode(data.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      stderr.write('Signup error: $e');
      return false;
    }
  }
}
