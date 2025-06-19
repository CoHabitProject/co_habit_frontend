import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';

abstract class FoyerRepository {
  Future<bool> creerFoyer(FoyerEntity formData);
  Future<FoyerEntity> getFoyerByCode(String code);
}
