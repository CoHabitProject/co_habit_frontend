import 'package:co_habit_frontend/domain/entities/tache_entity.dart';

class TacheModel extends TacheEntity {
  TacheModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.title,
      required super.category,
      required super.date,
      required super.status});

  factory TacheModel.fromJson(Map<String, dynamic> json) {
    return TacheModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        title: json['title'],
        category: json['category'],
        date: json['date'],
        status: json['status']);
  }

  factory TacheModel.fromEntity(TacheEntity entity) {
    return TacheModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        title: entity.title,
        category: entity.category,
        date: entity.date,
        status: entity.status);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'title': title,
      'category': category,
      'date': date,
      'status': status.name
    };
  }
}
