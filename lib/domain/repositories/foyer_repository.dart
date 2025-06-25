import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';

abstract class FoyerRepository {
  Future<FoyerEntity> creerFoyer(CreerFoyerRequest request);
  Future<FoyerEntity> getFoyerByCode(String code);
}
