import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/foyer_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/foyer_repository.dart';
import 'package:get_it/get_it.dart';

class FoyerRepositoryImpl implements FoyerRepository {
  final FoyerRemoteDatasource remoteDataSource;
  final _log = GetIt.instance<LogService>();

  FoyerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FoyerEntity> creerFoyer(CreerFoyerRequest request) async {
    try {
      return await remoteDataSource.creerFoyer(request);
    } catch (e) {
      _log.error('[FoyerRepositoryImpl] Repository Error: $e');
      rethrow;
    }
  }

  @override
  Future<FoyerEntity> getFoyerByCode(String code) async {
    try {
      return await remoteDataSource.getFoyerByCode(code);
    } catch (e) {
      _log.error(
          '[FoyerRepositoryImpl] Repository Error on getFoyerByCode: $e');
      rethrow;
    }
  }

  @override
  Future<FoyerEntity> getFoyerById(int id) async {
    try {
      return await remoteDataSource.getFoyerById(id);
    } catch (e) {
      _log.error('[FoyerRepositoryImpl] Repository Error on getFoyerById: $e');
      rethrow;
    }
  }
}
