import 'package:co_habit_frontend/domain/entities/tache_entity.dart';

abstract class TacheRepository {
  Future<List<TacheEntity>> getAllTaches(int colocationId);
  Future<List<TacheEntity>> getLastCreatedTaches(int colocationId);
  Future<TacheEntity> getTacheById(int id, int colocationId);
  Future<void> createTache(TacheEntity tache, int colocationId);
}
