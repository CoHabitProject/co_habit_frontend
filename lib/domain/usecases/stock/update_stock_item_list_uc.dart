import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/domain/repositories/stock_item_repository.dart';

class UpdateStockItemListUc {
  final StockItemRepository stockItemRepository;

  UpdateStockItemListUc({required this.stockItemRepository});

  Future<void> execute(
      Map<int, StockItemRequest> updates, int colocationId, int stockId) async {
    await Future.wait(updates.entries.map((entry) => stockItemRepository
        .updateStockItems(entry.value, colocationId, stockId, entry.key)));
  }
}
