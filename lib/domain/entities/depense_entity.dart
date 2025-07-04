import 'package:co_habit_frontend/domain/entities/utilisateur_entity.dart';

class DepenseEntity {
  final int id;
  final String title;
  final String description;
  final double amount;
  final DateTime createdAt;
  final DateTime? settledAt;
  final UtilisateurEntity user;
  final bool settled;

  DepenseEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      required this.createdAt,
      this.settledAt,
      required this.user,
      required this.settled});
}
