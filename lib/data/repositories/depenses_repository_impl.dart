import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:co_habit_frontend/data/models/requests/depense_request.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/depenses_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/depense_entity.dart';
import 'package:co_habit_frontend/domain/repositories/depenses_repository.dart';
import 'package:get_it/get_it.dart';

class DepensesRepositoryImpl implements DepensesRepository {
  final DepensesRemoteDatasource remoteDatasource;
  final _log = GetIt.instance<LogService>();

  DepensesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<DepenseEntity>> getAllDepenses(int colocationId) async {
    try {
      return await remoteDatasource.getAllDepenses(colocationId);
    } catch (e, stack) {
      _log.error('[DepensesRepositoryImpl] Error on getAllDepenses: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<DepenseEntity> save(DepenseRequest request) async {
    try {
      return await remoteDatasource.save(request);
    } catch (e, stack) {
      _log.error('[DepensesRepositoryImpl] Error on save: $e',
          stackTrace: stack);
      rethrow;
    }
  }
}
