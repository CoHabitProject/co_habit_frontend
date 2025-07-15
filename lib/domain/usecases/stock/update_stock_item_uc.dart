import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/domain/repositories/stock_item_repository.dart';

class UpdateStockItemUc {
  final StockItemRepository stockItemRepository;

  UpdateStockItemUc({required this.stockItemRepository});

  Future<void> execute(StockItemRequest request, int colocationId, int stockId,
      int itemId) async {
    await stockItemRepository.updateStockItems(
        request, colocationId, stockId, itemId);
  }
}
