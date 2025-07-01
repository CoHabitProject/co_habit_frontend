import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/domain/entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getLowestStock();
  Future<List<StockEntity>> getAllStock();
  Future<StockEntity> updateStock(StockRequest stock);
  Future<StockEntity> save(StockRequest stock, int colocationId);
}
