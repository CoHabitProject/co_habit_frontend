import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/entities/depense_entity.dart';

class DepenseModel extends DepenseEntity {
  DepenseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.amount,
    required super.createdAt,
    super.settledAt,
    required super.user,
    required super.settled,
  });

  factory DepenseModel.fromJson(Map<String, dynamic> json) {
    return DepenseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      settledAt:
          json['settledAt'] != null ? DateTime.parse(json['settledAt']) : null,
      user: UtilisateurModel.fromJson(json['payer']),
      settled: json['settled'],
    );
  }

  factory DepenseModel.fromEntity(DepenseEntity entity) {
    return DepenseModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        amount: entity.amount,
        createdAt: entity.createdAt,
        user: entity.user,
        settled: entity.settled);
  }

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
