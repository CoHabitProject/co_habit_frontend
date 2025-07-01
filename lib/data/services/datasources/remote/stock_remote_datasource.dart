import 'dart:io';

import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/requests/creer_stock_item_request.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';

import 'package:co_habit_frontend/data/models/models.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

abstract class StockRemoteDatasource {
  Future<List<StockModel>> getLowestStock();
  Future<List<StockModel>> getAllStock(int colocationId);
  Future<StockModel> updateStock(StockRequest stock);
  Future<StockModel> save(StockRequest stock, int colocationId);
  Future<StockItemModel> addItemToStock(
      int colocationId, int stockId, CreerStockItemRequest request);
}

class StockRemoteDatasourceImpl implements StockRemoteDatasource {
  final Dio dio;
  final _log = GetIt.instance<LogService>();

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
      _log.error('API error on getLowestStock $e');
      rethrow;
    }
  }

  @override
  Future<List<StockModel>> getAllStock(int colocationId) async {
    try {
      final response = await dio.get(AppConstants.stockMainRoute(colocationId));
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => StockModel.fromJson(json)).toList();
      }
      return List.empty();
    } catch (e) {
      _log.error('API error on getAllStock: $e');
      rethrow;
    }
  }

  @override
  Future<StockModel> updateStock(StockRequest stock) async {
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

  @override
  Future<StockModel> save(StockRequest stock, int colocationId) async {
    try {
      final response = await dio.post(AppConstants.stockMainRoute(colocationId),
          data: stock,
          options: Options(
            validateStatus: (status) => status != null && status < 400,
          ));
      final json = response.data;

      if (response.statusCode == 201) {
        return StockModel.fromJson(json);
      }
      throw Exception(
          'Error on save, requête en erreur : ${response.statusCode}');
    } catch (e) {
      _log.error('API error on save: $e');
      rethrow;
    }
  }

  @override
  Future<StockItemModel> addItemToStock(
      int colocationId, int stockId, CreerStockItemRequest request) async {
    try {
      final response = await dio.post(
          AppConstants.creerStockItemRoute(colocationId, stockId),
          data: request.toJson());
      if (response.statusCode == 201) {
        return StockItemModel.fromJson(response.data);
      }
      throw Exception('[StockRemoteDatasource] Erreur on addItemToStock');
    } catch (e, stack) {
      _log.error('[StockRemoteDatasource] API error on addItemToStock: $e',
          stackTrace: stack);
      rethrow;
    }
  }
}
