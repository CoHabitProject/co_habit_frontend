import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/entities/user_credentials.dart';

abstract class AuthRepository {
  Future<bool> login(UserCredentials credentials);
  Future<bool> signup(RegisterData data);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> refreshToken();
}