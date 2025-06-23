import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getLowestStock();
  Future<List<StockEntity>> getAllStock();
  Future<StockEntity> updateStock(StockModel stock);
}
