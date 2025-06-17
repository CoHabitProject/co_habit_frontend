import 'dart:io';

import 'package:co_habit_frontend/data/models/tache_model.dart';
import 'package:dio/dio.dart';

abstract class TacheRemoteDatasource {
  Future<void> creerTache(TacheModel model);
  Future<List<TacheModel>> getAllTaches();
  Future<List<TacheModel>> getLastCreatedTaches();
  Future<TacheModel> getTacheById(int id);
}

class TacheRemoteDatasourceImpl implements TacheRemoteDatasource {
  final Dio dio;

  TacheRemoteDatasourceImpl({required this.dio});

  @override
  Future<void> creerTache(TacheModel model) async {
    try {
      await dio.post('/tache/creer', data: model.toJson());
    } catch (e) {
      stderr.write('API error: $e');
    }
  }

  @override
  Future<List<TacheModel>> getAllTaches() async {
    try {
      final response = await dio.get('/tache/getAll');
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => TacheModel.fromJson(json)).toList();
      }
      return List.empty();
    } catch (e) {
      stderr.write('API error in getAlltaches: $e');
      rethrow;
    }
  }

  @override
  Future<List<TacheModel>> getLastCreatedTaches() async {
    try {
      final response = await dio.get('/tache/getAll');
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => TacheModel.fromJson(json)).toList();
      }
      return List.empty();
    } catch (e) {
      stderr.write('API error in getLastCreatedTaches: $e');
      rethrow;
    }
  }

  @override
  Future<TacheModel> getTacheById(int id) async {
    try {
      final response = await dio.get('/tache/getById/$id');
      return TacheModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      stderr.write('API error in getTacheById avec l\'id $id: $e');
      rethrow;
    }
  }
}
