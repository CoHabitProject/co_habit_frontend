import 'dart:io';
import 'package:co_habit_frontend/data/models/creer_foyer_model.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/foyer_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/creer_foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/creer_foyer_repository.dart';

class CreerFoyerRepositoryImpl implements CreerFoyerRepository {
  final FoyerRemoteDatasource remoteDataSource;

  CreerFoyerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> creerFoyer(CreerFoyerEntity formData) async {
    try {
      final CreerFoyerModel model = CreerFoyerModel.fromEntity(formData);
      return await remoteDataSource.creerFoyer(model);
    } catch (e) {
      stderr.write('Repository Error: $e');
      return false;
    }
  }
}
