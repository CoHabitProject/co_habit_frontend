import 'dart:io';
import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/foyer_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/foyer_repository.dart';

class FoyerRepositoryImpl implements FoyerRepository {
  final FoyerRemoteDatasource remoteDataSource;

  FoyerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> creerFoyer(FoyerEntity formData) async {
    try {
      final FoyerModel model = FoyerModel.fromEntity(formData);
      return await remoteDataSource.creerFoyer(model);
    } catch (e) {
      stderr.write('Repository Error: $e');
      return false;
    }
  }

  @override
  Future<FoyerEntity> getFoyerByCode(String code) async {
    try {
      // TODO : Decommenter quand quand back OK
      // return await remoteDataSource.getFoyerByCode(code);
      return FoyerModel(
          id: 1,
          name: 'Super coloc',
          ville: 'Lyon',
          adresse: '12 Rue de Lyon',
          codePostal: '69003',
          nbPersonnes: 4,
          dateEntree: '10/10/2025',
          code: '38256',
          membres: [
            UtilisateurModel(
                id: 1,
                firstName: 'Carlos',
                lastName: 'Ceren',
                email: 'carlosceren@email.fr',
                dateDeNaissance: DateTime(201, 07, 28),
                dateEntree: DateTime(2025, 10, 10)),
            UtilisateurModel(
                id: 1,
                firstName: 'Axel',
                lastName: 'Gallic',
                email: 'awxelGallic@email.fr',
                dateDeNaissance: DateTime(201, 07, 28),
                dateEntree: DateTime(2025, 10, 10)),
            UtilisateurModel(
                id: 1,
                firstName: 'Bertrand',
                lastName: 'Renaudin',
                email: 'bertrandrenaudin@email.fr',
                dateDeNaissance: DateTime(201, 07, 28),
                dateEntree: DateTime(2025, 10, 10)),
            UtilisateurModel(
                id: 1,
                firstName: 'Dmitri',
                lastName: 'Chine',
                email: 'dmitrichine@email.fr',
                dateDeNaissance: DateTime(201, 07, 28),
                dateEntree: DateTime(2025, 10, 10)),
          ]);
    } catch (e) {
      stderr.write('Repository Error on getFoyerByCode: $e');
      rethrow;
    }
  }
}
