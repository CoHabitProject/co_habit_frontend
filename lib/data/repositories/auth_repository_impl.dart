import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/auth_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;
  final TokenService tokenService;
  final CurrentUserService currentUserService;
  final LogService log;

  AuthRepositoryImpl(
      {required this.datasource,
      required this.tokenService,
      required this.currentUserService,
      required this.log});

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
    if (oldCredentials == null) return false;

    final newCredentials =
        await datasource.refreshToken(oldCredentials.refreshToken);
    if (newCredentials == null) return false;

    // Sauvegarder les nouveaux credentials
    await tokenService.saveCredentials(newCredentials);

    // Mettre à jour le current user
    await currentUserService.saveUser(newCredentials.user);

    return true;
  }

  @override
  Future<UtilisateurModel?> getCurrentUser() async {
    return await currentUserService.getUser();
  }
}
