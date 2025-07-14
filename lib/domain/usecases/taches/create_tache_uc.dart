import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class CreerTacheUc {
  final TacheRepository tachesRepository;

  CreerTacheUc(this.tachesRepository);

  Future<void> execute(TacheEntity tache, int colocationId) async =>
      await tachesRepository.createTache(tache, colocationId);
}