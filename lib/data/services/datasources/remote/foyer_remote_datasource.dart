import 'dart:io';

import 'package:co_habit_frontend/data/models/creer_foyer_model.dart';
import 'package:dio/dio.dart';

abstract class FoyerRemoteDatasource {
  Future<bool> creerFoyer(CreerFoyerModel formData);
}

class FoyerRemoteDataSourceImpl implements FoyerRemoteDatasource {
  final Dio dio;

  FoyerRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> creerFoyer(CreerFoyerModel formData) async {
    try {
      final response = await dio.post('/foyer/creer', data: formData.toJson());
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      stderr.write('API Error: $e');
      return false;
    }
  }
}
