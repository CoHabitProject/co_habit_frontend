import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class CreerStockItemUc {
  final StockItemRepository stockItemRepository;

  CreerStockItemUc({required this.stockItemRepository});

  Future<StockItemEntity> execute(
          int colocationId, int stockId, StockItemRequest request) async =>
      await stockItemRepository.addItemToStock(colocationId, stockId, request);
}
