import 'package:co_habit_frontend/domain/entities/utilisateur_entity.dart';

abstract class FoyerEntity {
  final int id;
  final String name;
  final String ville;
  final String adresse;
  final String codePostal;
  final int nbPersonnes;
  final String dateEntree;
  final String code;
  final List<UtilisateurEntity> membres;

  const FoyerEntity(
      {required this.id,
      required this.name,
      required this.ville,
      required this.adresse,
      required this.codePostal,
      required this.nbPersonnes,
      required this.dateEntree,
      required this.code,
      required this.membres});
}
