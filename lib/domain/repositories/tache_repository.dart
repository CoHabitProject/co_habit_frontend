import 'package:co_habit_frontend/domain/entities/tache_entity.dart';

abstract class TacheRepository {
  Future<List<TacheEntity>> getAllTaches();
  Future<List<TacheEntity>> getLastCreatedTaches();
  Future<TacheEntity> getTacheById(int id);
  Future<void> createTache(TacheEntity tache);
}
