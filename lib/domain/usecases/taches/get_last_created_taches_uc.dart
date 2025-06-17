import 'package:co_habit_frontend/domain/entities/tache_entity.dart';
import 'package:co_habit_frontend/domain/repositories/tache_repository.dart';

class GetLastCreatedTachesUc {
  final TacheRepository repository;

  GetLastCreatedTachesUc(this.repository);

  Future<List<TacheEntity>> execute() async =>
      await repository.getLastCreatedTaches();
}
