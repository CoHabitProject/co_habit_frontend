import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/foyer_repository.dart';

class CreerFoyerUseCase {
  final FoyerRepository repository;

  CreerFoyerUseCase(this.repository);

  Future<FoyerEntity> execute(CreerFoyerRequest request) async {
    return await repository.creerFoyer(request);
  }
}
