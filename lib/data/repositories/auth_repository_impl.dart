import 'package:co_habit_frontend/data/services/datasources/remote/auth_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/entities/user_credentials.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<bool> login(UserCredentials credentials){
    return datasource.login(credentials);
  }

  Future<bool> signup(RegisterData data){
    return datasource.signup(data);
  }

  Future<void> logout(){
    return datasource.logout();
  }

  Future<String?> getToken(){
    //return datasource.storage.read(key:'jwt');
    return datasource.getToken();
  }

  Future<bool> refreshToken(){
    return datasource.refreshToken();
  }
}