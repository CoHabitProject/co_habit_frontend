import 'package:co_habit_frontend/domain/entities/user_credentials.dart';

abstract class AuthRepository {
  Future<bool> login(UserCredentials credentials);
  Future<bool> signup();
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> refreshToken();
}