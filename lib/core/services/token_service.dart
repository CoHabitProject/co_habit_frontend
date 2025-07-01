import 'dart:convert';

import 'package:co_habit_frontend/domain/entities/user_credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _credentialsKey = 'user_credentials';

  Future<void> saveCredentials(UserCredentials credentials) async {
    // Récupération de shared preferences et sauvegarde des credentials
    final prefs = await SharedPreferences.getInstance();
    // En encode les credentials
    final jsonString = jsonEncode(credentials.toJson());
    await prefs.setString(_credentialsKey, jsonString);
  }

  Future<UserCredentials?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_credentialsKey);
    // Si valeur dans shared preferences vide on retourne null
    if (jsonString == null) return null;

    // on decode et retourne le model
    final json = jsonDecode(jsonString);
    return UserCredentials.fromJson(json);
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }

  Future<String?> getAccessToken() async {
    final credentials = await getCredentials();
    return credentials?.accessToken;
  }

  Future<bool> isTokenExpired() async {
    final credentials = await getCredentials();
    // Si pas de credentials on retourne true
    if (credentials == null) return true;

    return DateTime.now().isAfter(credentials.tokenExpiry);
  }
}
