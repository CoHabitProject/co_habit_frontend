import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final TokenService tokenService;
  final CurrentUserService currentUserService;

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

    // Verification des credentials
    if (credentials != null) {
      final expired = await tokenService.isTokenExpired();

      if (expired) {
        final refreshed = await authRepository.refreshToken();

        if (!refreshed) {
          // purge tout si le refresj échoue
          await logout();
          _initialized = true;
          notifyListeners();
          return;
        }
      }

      _user = await currentUserService.getUser();
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
