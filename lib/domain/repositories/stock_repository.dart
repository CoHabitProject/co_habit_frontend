import 'package:co_habit_frontend/domain/entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getLowestStock();
}
