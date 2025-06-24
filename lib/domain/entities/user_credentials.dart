import 'package:co_habit_frontend/data/models/utilisateur_model.dart';

class UserCredentials {
  final String accessToken;
  final String refreshToken;
  final DateTime tokenExpiry;
  final UtilisateurModel user;

  UserCredentials(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenExpiry,
      required this.user});

  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      tokenExpiry: DateTime.parse(json['tokenExpiry']),
      user: UtilisateurModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenExpiry': tokenExpiry.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
