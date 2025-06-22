import 'dart:convert';
import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/entities/user_credentials.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRemoteDatasource {
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthRemoteDatasource(this.dio,this.storage);

  Future<bool> login(UserCredentials credentials)async{
    try {
      final response = await dio.post(
        AppConstants.login,
        data: jsonEncode(credentials.toJson()),
      );

      if(response.statusCode == 200 && response.data != null) {
        final tokens=response.data;
        await storage.write(key:'jwt',value:tokens['access_token']);
        // POUR DEBUG
        // final savedToken = await storage.read(key:'jwt');
        // print('>>> TOKEN ENREGISTRE : $savedToken');
        await storage.write(key:'refreshToken',value:tokens['refresh_token']);
        return true;
      }
    }catch(e){
      print('login errror : $e');
    }
    return false;
  }

  Future<bool> signup(RegisterData data) async {
    try {
      final response = await dio.post(
        AppConstants.register,
        data: jsonEncode(data.toJson())
      );

      if(response.statusCode == 201) {
        return true;
      }
    } catch(e) {
      print('Signup error : $e');
    }
    return false;
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      if(refreshToken==null)return false;
      final response=await dio.post(
          AppConstants.refresh,
          data: jsonEncode({'refreshToken': refreshToken})
      );
      if(response.statusCode==200){
        final tokens=response.data;
        await storage.write(key: 'jwt',value:tokens['accessToken']);
        return true;
      }
    }catch(e){
      print('Refresh token error $e');
    }
    return false;
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'refreshToken');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<Map<String, dynamic>?> getUserStatus() async {
    try {
      final response=await dio.get(AppConstants.userStatus);
      if(response.statusCode==200){
        return response.data;
      }
    }catch(e){
      print('Get user status error : $e');
    }
    return null;
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if(parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }
}