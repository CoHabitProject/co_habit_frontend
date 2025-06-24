import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/foyer_repository.dart';

class CreerFoyerUseCase {
  final FoyerRepository repository;

  CreerFoyerUseCase(this.repository);

  Future<FoyerEntity> execute(FoyerEntity formData) async {
    return await repository.creerFoyer(formData);
  }
}
