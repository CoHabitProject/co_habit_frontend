import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/depense_model.dart';
import 'package:co_habit_frontend/data/models/requests/depense_request.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

abstract class DepensesRemoteDatasource {
  Future<List<DepenseModel>> getAllDepenses(int colocationId);
  Future<DepenseModel> save(DepenseRequest request, int colocationId);
}

class DepensesRemoteDatasourceImpl implements DepensesRemoteDatasource {
  final Dio dio;
  final _log = GetIt.instance<LogService>();

  DepensesRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<DepenseModel>> getAllDepenses(int colocationId) async {
    try {
      final response =
          await dio.get(AppConstants.getDepensesDuFoyerRoute(colocationId));
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => DepenseModel.fromJson(json)).toList();
      }
      throw Exception('[DepensesRemoteDatasourceImpl] Error on getAllDepenses');
    } catch (e, stack) {
      _log.error(
          '[DepensesRemoteDatasourceImpl] API erorr on getAllDepenses: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<DepenseModel> save(DepenseRequest request, int colocationId) async {
    try {
      final response = await dio.post(AppConstants.creerDepenseRoute,
          data: request.toJson());

      if (response.statusCode == 201) {
        return DepenseModel.fromJson(response.data);
      }
      throw Exception('[DepensesRemoteDatasourceImpl] Error on save');
    } catch (e, stack) {
      _log.error('[DepensesRemoteDatasourceImpl] API Errro on save: $e',
          stackTrace: stack);
      rethrow;
    }
  }
}
