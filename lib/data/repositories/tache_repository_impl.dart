import 'dart:io';

import 'package:co_habit_frontend/data/models/tache_model.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/tache_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/tache_entity.dart';
import 'package:co_habit_frontend/domain/repositories/tache_repository.dart';
import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';

class TacheRepositoryImpl implements TacheRepository {
  final TacheRemoteDatasource tacheRemoteDatasource;

  TacheRepositoryImpl({required this.tacheRemoteDatasource});

  @override
  Future<void> createTache(TacheEntity tache) async {
    try {
      await tacheRemoteDatasource.creerTache(TacheModel.fromEntity(tache));
    } catch (e) {
      stderr.write('Repository Error in createTache: $e');
    }
  }

  @override
  Future<List<TacheEntity>> getAllTaches() async {
    try {
      return await tacheRemoteDatasource.getAllTaches();
    } catch (e) {
      stderr.write('Repository Error in getAllTaches: $e');
      rethrow;
    }
  }

  @override
  Future<List<TacheEntity>> getLastCreatedTaches() async {
    try {
      // TODO : Remplacer quand backend finis
      // return await tacheRemoteDatasource.getLastCreatedTaches();
      return [
        TacheModel(
          id: 1,
          firstName: 'Carlos',
          lastName: 'Ceren',
          title: 'Réparer lavabo',
          category: 'Réparation',
          date: DateTime(2025, 5, 31),
          status: TacheStatus.termine,
        ),
        TacheModel(
          id: 2,
          firstName: 'Bertrand',
          lastName: 'Renaudin',
          title: 'Faire la vaisselle',
          category: 'Ménage',
          date: DateTime(2025, 5, 22),
          status: TacheStatus.enAttente,
        ),
        TacheModel(
          id: 3,
          firstName: 'Dmitri',
          lastName: 'Chine',
          title: 'Acheter PQ',
          category: 'Courses',
          date: DateTime(2025, 5, 23),
          status: TacheStatus.enCours,
        ),
      ];
    } catch (e) {
      stderr.write('Repository Error in getLastCreatedTaches: $e');
      rethrow;
    }
  }

  @override
  Future<TacheEntity> getTacheById(int id) async {
    try {
      return await tacheRemoteDatasource.getTacheById(id);
    } catch (e) {
      stderr.write('Repository Error in getTacheById: $e');
      rethrow;
    }
  }
}
