import 'package:co_habit_frontend/domain/entities/creer_foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/creer_foyer_repository.dart';

class CreerFoyerUseCase {
  final CreerFoyerRepository repository;

  CreerFoyerUseCase(this.repository);

  Future<bool> execute(CreerFoyerEntity formData) async {
    return await repository.creerFoyer(formData);
  }
}
