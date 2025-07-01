import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class GetAllStockItemsUc {
  final StockItemRepository stockItemRepository;

  GetAllStockItemsUc({required this.stockItemRepository});

  Future<List<StockItemEntity>> execute(int colocationId, int stockId) async {
    return await stockItemRepository.getAllItems(colocationId, stockId);
  }
}
