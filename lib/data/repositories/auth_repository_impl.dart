import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/auth_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/entities/user_credentials.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('foyerId');
  }

  @override
  Future<UtilisateurModel?> getCurrentUser() async {
    return await currentUserService.getUser();
  }

  @override
  Future<UserCredentials?> refreshToken() async {
    try {
      final oldCredentials = await tokenService.getCredentials();
      if (oldCredentials == null) {
        log.warn('[Repository] refreshToken → No stored credentials found.');
        return null;
      }

      final oldRefreshToken = oldCredentials.refreshToken;
      log.debug(
          '[Repository] refreshToken → Using old token: $oldRefreshToken');

      final newCredentials = await datasource.refreshToken(oldRefreshToken);

      if (newCredentials != null) {
        await tokenService.saveCredentials(newCredentials);
        await currentUserService.saveUser(newCredentials.user);
        log.debug(
            '[Repository] refreshToken -> credentials saved successfully');
        return newCredentials;
      }
    } catch (e, stack) {
      log.error('[Repository] refreshToken → $e', stackTrace: stack);
    }

    return null;
  }
}
