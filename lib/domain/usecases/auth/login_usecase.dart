import 'package:co_habit_frontend/domain/entities/user_credentials.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<bool> call(UserCredentials credentials){
    return repository.login(credentials);
  }
}