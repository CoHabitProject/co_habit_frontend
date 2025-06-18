import 'package:co_habit_frontend/domain/entities/creer_foyer_entity.dart';

abstract class CreerFoyerRepository {
  Future<bool> creerFoyer(CreerFoyerEntity formData);
}
