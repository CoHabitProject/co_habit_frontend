import 'package:co_habit_frontend/domain/repositories/stock_item_repository.dart';

class DeleteStockItemUc {
  final StockItemRepository stockItemRepository;

  DeleteStockItemUc({required this.stockItemRepository});

  Future<void> execute(int colocationId, int stockId, int itemId) async {
    return await stockItemRepository.deleteItem(colocationId, stockId, itemId);
  }
}
