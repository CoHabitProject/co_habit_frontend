import 'package:co_habit_frontend/domain/entities/creer_foyer_entity.dart';

class CreerFoyerModel extends CreerFoyerEntity {
  CreerFoyerModel(
      {required super.name,
      required super.ville,
      required super.adresse,
      required super.codePostal,
      required super.nbPersonnes,
      required super.dateEntree});

  factory CreerFoyerModel.fromJson(Map<String, dynamic> json) {
    return CreerFoyerModel(
        name: json['name'] ?? '',
        ville: json['ville'] ?? '',
        adresse: json['adresse'] ?? '',
        codePostal: json['codePostal'] ?? '',
        nbPersonnes: json['nbPersonnes'] ?? '',
        dateEntree: json['dateEntree'] ?? '');
  }

  factory CreerFoyerModel.fromEntity(CreerFoyerEntity entity) {
    return CreerFoyerModel(
        name: entity.name,
        ville: entity.ville,
        adresse: entity.adresse,
        codePostal: entity.codePostal,
        nbPersonnes: entity.nbPersonnes,
        dateEntree: entity.dateEntree);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ville': ville,
      'adresse': adresse,
      'codePostal': codePostal,
      'nbPersonnes': nbPersonnes,
      'dateEntree': dateEntree
    };
  }
}
