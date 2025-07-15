import 'package:co_habit_frontend/data/models/requests/requests.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class UpdateStockUc {
  final StockRepository stockRepository;

  UpdateStockUc({required this.stockRepository});

  Future<StockEntity> execute(
          StockRequest request, int stockId, int colocationId) async =>
      await stockRepository.updateStock(request, stockId, colocationId);
}
