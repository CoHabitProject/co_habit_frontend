import 'dart:io';

import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:dio/dio.dart';

abstract class FoyerRemoteDatasource {
  Future<bool> creerFoyer(FoyerModel formData);
  Future<FoyerModel> getFoyerByCode(String code);
}

class FoyerRemoteDataSourceImpl implements FoyerRemoteDatasource {
  final Dio dio;

  FoyerRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> creerFoyer(FoyerModel formData) async {
    try {
      final response = await dio.post('/foyer/creer', data: formData.toJson());
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      stderr.write('API Error on creerFoyer: $e');
      return false;
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
      stderr.write('API Error on getFoyerByCode: $e');
      rethrow;
    }
  }
}
