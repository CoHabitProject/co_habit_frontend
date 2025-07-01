import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';

abstract class AuthRepository {
  Future<bool> login(String username, String password);
  Future<bool> signup(RegisterData data);
  Future<void> logout();
  Future<UserCredentials?> refreshToken();
  Future<UtilisateurModel?> getCurrentUser();
}
