import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final TokenService tokenService;
  final CurrentUserService currentUserService;

  final _log = GetIt.instance<LogService>();

  UtilisateurModel? _user;
  bool _initialized = false;

  AuthProvider(
      {required this.authRepository,
      required this.tokenService,
      required this.currentUserService});

  UtilisateurModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _initialized;

// Appelé au lancement de l'app (main)
  Future<void> initAuth() async {
    final credentials = await tokenService.getCredentials();
    _log.info(
        '[AUTO LOGIN] Credentials trouvés: ${credentials?.user.toJson()}');

    if (credentials != null) {
      final isExpired = await tokenService.isTokenExpired();
      _log.debug('[AUTO LOGIN] Token expiré: $isExpired');

      if (isExpired) {
        _log.warn(
            '[AUTO LOGIN] Token expiré mais on attend la prochaine requête pour le refresh via Interceptor.');
        _user = credentials.user; // On garde les credentials existants
      } else {
        // Token encore valide → récupération du user
        _user = await currentUserService.getUser();
      }
    } else {
      _log.info(
          '[AUTO LOGIN] Aucun credentials trouvés → utilisateur non connecté.');
    }

    _initialized = true;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final success = await authRepository.login(username, password);

    if (success) {
      _user = await currentUserService.getUser();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await authRepository.logout();
    _user = null;
    notifyListeners();
  }
}
