import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';

abstract class StockItemRepository {
  Future<List<StockItemEntity>> getAllItems(int colocationId, int stockId);
  Future<StockItemEntity> addItemToStock(
      int colocationId, int stockId, StockItemRequest request);
  Future<void> updateStockItems(
      StockItemRequest request, int colocationId, int stockId, int itemId);
  Future<void> deleteItem(int colocationId, int stockId, int itemId);
}
