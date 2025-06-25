import 'package:co_habit_frontend/domain/entities/utilisateur_entity.dart';

class UtilisateurModel extends UtilisateurEntity {
  final String keyCloakSub;
  final String phoneNumber;
  final String username;
  final String fullName;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  UtilisateurModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.dateDeNaissance,
    required this.keyCloakSub,
    required this.phoneNumber,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
      id: json['id'],
      keyCloakSub: json['keyCloakSub'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      dateDeNaissance:
          DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime(1900),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  factory UtilisateurModel.fromEntity(UtilisateurEntity entity) {
    return UtilisateurModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      dateDeNaissance: entity.dateDeNaissance,
      keyCloakSub: '',
      phoneNumber: '',
      username: '',
      fullName: '${entity.firstName} ${entity.lastName}',
      gender: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyCloakSub': keyCloakSub,
      'email': email,
      'phoneNumber': phoneNumber,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'birthDate': dateDeNaissance.toIso8601String(),
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime(1900);
    } else if (value is List) {
      // Format [YYYY, MM, DD, hh, mm, ss, nnnnnn]
      return DateTime(
        value[0],
        value[1],
        value[2],
        value.length > 3 ? value[3] : 0,
        value.length > 4 ? value[4] : 0,
        value.length > 5 ? value[5] : 0,
        value.length > 6 ? value[6] ~/ 1000 : 0,
      );
    } else {
      return DateTime(1900);
    }
  }
}
