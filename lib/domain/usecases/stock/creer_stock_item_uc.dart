import 'package:co_habit_frontend/data/models/requests/creer_stock_item_request.dart';
import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class CreerStockItemUc {
  final StockRepository stockRepository;

  CreerStockItemUc({required this.stockRepository});

  Future<StockItemEntity> execute(
          int colocationId, int stockId, CreerStockItemRequest request) async =>
      await stockRepository.addItemToStock(colocationId, stockId, request);
}
