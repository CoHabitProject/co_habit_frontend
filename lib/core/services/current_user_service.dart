import 'dart:convert';

import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUserService {
  static const _userKey = 'current_user';

  Future<void> saveUser(UtilisateurModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // en encode l'utilisateur avant de le sauvegarder dans les sharedPreferences
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }

  Future<UtilisateurModel?> getUser() async {
    // Récupération de la valeur encodé
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);

    if (jsonString == null) return null;

    // Decode de la valeur et return du model
    final json = jsonDecode(jsonString);
    return UtilisateurModel.fromJson(json);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
