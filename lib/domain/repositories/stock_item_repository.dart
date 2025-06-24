import 'package:co_habit_frontend/data/models/stock_item_model.dart';

abstract class StockItemRepository {
  Future<void> createItem(StockItemModel item);
  Future<void> deleteItem(StockItemModel item);
  Future<void> changeQuantity(int quantity, int id);
}
