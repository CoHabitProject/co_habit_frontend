import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/auth_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;
  final TokenService tokenService;
  final CurrentUserService currentUserService;

  AuthRepositoryImpl(
      {required this.datasource,
      required this.tokenService,
      required this.currentUserService});

  @override
  Future<bool> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final credentials = await datasource.login(request);

    if (credentials == null) return false;

    await tokenService.saveCredentials(credentials);
    await currentUserService.saveUser(credentials.user);
    return true;
  }

  @override
  Future<bool> signup(RegisterData data) {
    return datasource.signup(data);
  }

  @override
  Future<void> logout() async {
    await tokenService.clearCredentials();
    await currentUserService.clearUser();
  }

  @override
  Future<bool> refreshToken() async {
    final oldCredentials = await tokenService.getCredentials();
    // Verification si oldCredentials existent
    if (oldCredentials == null) return false;

    final refreshed =
        await datasource.refreshToken(oldCredentials.refreshToken);
    // on verifie qu'on as pas rétourné null
    if (refreshed == null) return false;

    await tokenService.saveCredentials(refreshed);
    await currentUserService.saveUser(refreshed.user);
    return true;
  }

  @override
  Future<UtilisateurModel?> getCurrentUser() async {
    return await currentUserService.getUser();
  }
}
