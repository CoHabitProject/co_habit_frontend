import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:dio/dio.dart';

abstract class FoyerRemoteDatasource {
  Future<FoyerModel> creerFoyer(CreerFoyerRequest request);
  Future<FoyerModel> getFoyerByCode(String code);
}

class FoyerRemoteDataSourceImpl implements FoyerRemoteDatasource {
  final Dio dio;
  final LogService log;

  FoyerRemoteDataSourceImpl({required this.dio, required this.log});

  @override
  Future<FoyerModel> creerFoyer(CreerFoyerRequest request) async {
    try {
      final response =
          await dio.post(AppConstants.colocations, data: request.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FoyerModel.fromJson(response.data);
      }
      throw Exception(
          'Erreur lors dans la réponse de la création du foyer avec le code ${response.statusCode}');
    } catch (e) {
      log.error('API Error on creerFoyer: $e');
      rethrow;
    }
  }

  @override
  Future<FoyerModel> getFoyerByCode(String code) async {
    try {
      final response = await dio.get('/get/foyerByCode/$code');
      final FoyerModel foyer = response.data;

      if (response.statusCode == 200) {
        return foyer;
      } else {
        throw Exception('Erreur API: Status code ${response.statusCode}');
      }
    } catch (e) {
      log.error('API Error on getFoyerByCode: $e');
      rethrow;
    }
  }
}
