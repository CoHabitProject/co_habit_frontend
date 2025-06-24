import 'package:co_habit_frontend/domain/entities/utilisateur_entity.dart';

class UtilisateurModel extends UtilisateurEntity {
  UtilisateurModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.dateDeNaissance,
      required super.dateEntree});

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        dateDeNaissance: json['dateDeNaissance'],
        dateEntree: json['dateEntree']);
  }

  factory UtilisateurModel.fromEntity(UtilisateurEntity entity) {
    return UtilisateurModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        email: entity.email,
        dateDeNaissance: entity.dateDeNaissance,
        dateEntree: entity.dateEntree);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateDeNaissance': dateDeNaissance,
      'dateEntree': dateEntree
    };
  }
}
