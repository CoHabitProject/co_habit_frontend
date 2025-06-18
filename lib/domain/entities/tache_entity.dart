import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';

abstract class TacheEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String title;
  final String category;
  final DateTime date;
  final TacheStatus status;

  TacheEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.title,
      required this.category,
      required this.date,
      required this.status});
}
