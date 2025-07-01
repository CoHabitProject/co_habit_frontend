import 'dart:io';

import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

abstract class StockItemRemoteDatasource {
  Future<StockItemModel> addItemToStock(
      int colocationId, int stockId, StockItemRequest request);
  Future<void> deleteItem(int colocationId, int stockId, int itemId);
  Future<void> updateStockItems(
      StockItemRequest request, int colocationId, int stockId, int itemId);
  Future<List<StockItemModel>> getAllItems(int colocationId, int stockId);
}

class StockItemRemoteDatasourceImpl implements StockItemRemoteDatasource {
  final Dio dio;

  final _log = GetIt.instance<LogService>();

  StockItemRemoteDatasourceImpl({required this.dio});

  @override
  Future<StockItemModel> addItemToStock(
      int colocationId, int stockId, StockItemRequest request) async {
    try {
      final response = await dio.post(
          AppConstants.stockItemMainRoute(colocationId, stockId),
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

  @override
  Future<List<StockItemModel>> getAllItems(
      int colocationId, int stockId) async {
    try {
      final response =
          await dio.get(AppConstants.stockItemMainRoute(colocationId, stockId));
      final List<dynamic> jsonList = response.data;

      if (response.statusCode == 200) {
        return jsonList.map((json) => StockItemModel.fromJson(json)).toList();
      }
      throw Exception(
          '[StockItemRemoteDatasource] Erreur lors de la récupération des items');
    } catch (e, stack) {
      _log.error('[StockItemRemoteDatasource] API error on getAllItems: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> updateStockItems(StockItemRequest request, int colocationId,
      int stockId, int itemId) async {
    try {
      final response = await dio.put(
          AppConstants.updateStockItemRoute(colocationId, stockId, itemId),
          data: request.toJson());
      if (response.statusCode == 200) {
        _log.debug('[StockItemRemoteDatasource] Stock mise à jour avec succès');
      }
    } catch (e, stack) {
      _log.error(
          '[StockItemRemoteDatasource] API error on updateStockItems: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteItem(int colocationId, int stockId, int itemId) async {
    try {
      final response = await dio.delete(
          AppConstants.deleteStockItemRoute(colocationId, stockId, itemId));
      if (response.statusCode == 204) {
        _log.debug('[StockItemRemoteDatasource] Stock supprimé avec succès');
      }
    } catch (e, stack) {
      _log.error('[StockItemRemoteDatasource] API error on deleteItem: $e',
          stackTrace: stack);
      rethrow;
    }
  }
}
