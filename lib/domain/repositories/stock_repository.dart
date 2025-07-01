import 'package:co_habit_frontend/data/models/requests/creer_stock_item_request.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/domain/entities/stock_entity.dart';
import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getLowestStock();
  Future<List<StockEntity>> getAllStock(int colocationId);
  Future<StockEntity> updateStock(StockRequest stock);
  Future<StockEntity> save(StockRequest stock, int colocationId);
  Future<StockItemEntity> addItemToStock(
      int colocationId, int stockId, CreerStockItemRequest request);
}
