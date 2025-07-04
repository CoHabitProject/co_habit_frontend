import 'package:co_habit_frontend/domain/entities/utilisateur_entity.dart';

class DepenseRequest {
  final int id;
  final String title;
  final String description;
  final double amount;
  final DateTime createdAt;
  final DateTime? settledAt;
  final UtilisateurEntity user;
  final bool settled;

  DepenseRequest(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      required this.createdAt,
      this.settledAt,
      required this.user,
      required this.settled});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'createdAt': createdAt,
      'settledAt': settledAt,
      'payer': user,
      'settled': settled,
    };
  }
}
