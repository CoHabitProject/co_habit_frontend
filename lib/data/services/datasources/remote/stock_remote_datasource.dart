import 'dart:io';

import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:dio/dio.dart';

abstract class StockRemoteDatasource {
  Future<List<StockModel>> getLowestStock();
  Future<List<StockModel>> getAllStock();
  Future<StockModel> updateStock(StockModel stock);
}

class StockRemoteDatasourceImpl implements StockRemoteDatasource {
  final Dio dio;

  StockRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<StockModel>> getLowestStock() async {
    try {
      final response = await dio.get('/stock/lowestStock');
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => StockModel.fromJson(json)).toList();
      }
      return List.empty();
    } catch (e) {
      stderr.write('API error on getLowestStock $e');
      rethrow;
    }
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    try {
      final response = await dio.get('/stock/getAll');
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => StockModel.fromJson(json)).toList();
      }
      return List.empty();
    } catch (e) {
      stderr.write('API error on getAllStock: $e');
      rethrow;
    }
  }

  @override
  Future<StockModel> updateStock(StockModel stock) async {
    try {
      final response = await dio.post('/stock/updateStock', data: stock);
      final json = response.data;

      if (response.statusCode == 200) {
        return StockModel.fromJson(json);
      }
      throw Exception('Error on updateStock, pas possbile de update');
    } catch (e) {
      stderr.write('API errror on updateStock: $e');
      rethrow;
    }
  }
}
