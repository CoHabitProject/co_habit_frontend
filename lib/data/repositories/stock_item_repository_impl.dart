import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/data/services/datasources/datasources.dart';
import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';
import 'package:get_it/get_it.dart';

class StockItemRepositoryImpl implements StockItemRepository {
  final StockItemRemoteDatasource remoteDatasource;

  StockItemRepositoryImpl({required this.remoteDatasource});

  final _log = GetIt.instance<LogService>();

  @override
  Future<StockItemEntity> addItemToStock(
      int colocationId, int stockId, StockItemRequest request) async {
    try {
      return await remoteDatasource.addItemToStock(
          colocationId, stockId, request);
    } catch (e, stack) {
      _log.error('[StockItemRepositoryImpl] Error on addItemToStock: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<StockItemEntity>> getAllItems(
      int colocationId, int stockId) async {
    try {
      return await remoteDatasource.getAllItems(colocationId, stockId);
    } catch (e, stack) {
      _log.error('[StockItemRepositoryImpl] Error on addItemToStock: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> updateStockItems(StockItemRequest request, int colocationId,
      int stockId, int itemId) async {
    try {
      return await remoteDatasource.updateStockItems(
          request, colocationId, stockId, itemId);
    } catch (e, stack) {
      _log.error('[StockItemRepositoryImpl] Error on updateStockItems: $e',
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteItem(int colocationId, int stockId, int itemId) async {
    try {
      return await remoteDatasource.deleteItem(colocationId, stockId, itemId);
    } catch (e, stack) {
      _log.error('[StockItemRepositoryImpl] Error on deleteItem: $e',
          stackTrace: stack);
      rethrow;
    }
  }
}
