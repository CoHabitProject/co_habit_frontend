import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';

class FoyerModel extends FoyerEntity {
  FoyerModel(
      {required super.id,
      required super.name,
      required super.ville,
      required super.adresse,
      required super.codePostal,
      required super.nbPersonnes,
      required super.dateEntree,
      required super.code,
      required super.membres});

  factory FoyerModel.fromJson(Map<String, dynamic> json) {
    return FoyerModel(
      id: json['id'],
      name: json['name'] ?? '',
      ville: json['city'] ?? '',
      adresse: json['adress'] ?? '',
      codePostal: json['postalCode'] ?? '',
      nbPersonnes: json['numberOfPeople'] ?? 0,
      dateEntree: json['dateEntree'] ?? '',
      code: json['invitationCode'] ?? '',
      membres: (json['users'] as List)
          .map((e) => UtilisateurModel.fromJson(e))
          .toList(),
    );
  }

  factory FoyerModel.fromEntity(FoyerEntity entity) {
    return FoyerModel(
        id: entity.id,
        name: entity.name,
        ville: entity.ville,
        adresse: entity.adresse,
        codePostal: entity.codePostal,
        nbPersonnes: entity.nbPersonnes,
        dateEntree: entity.dateEntree,
        code: entity.code,
        membres: entity.membres);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ville': ville,
      'adresse': adresse,
      'codePostal': codePostal,
      'nbPersonnes': nbPersonnes,
      'dateEntree': dateEntree,
      'invitationCode': code,
      'membres': membres
    };
  }
}
