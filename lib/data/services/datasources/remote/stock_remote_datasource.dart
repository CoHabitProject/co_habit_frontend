import 'dart:io';

import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:dio/dio.dart';

abstract class StockRemoteDatasource {
  Future<List<StockModel>> getLowestStock();
  Future<List<StockModel>> getAllStock();
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
}
