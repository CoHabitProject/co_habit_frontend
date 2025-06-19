import 'package:co_habit_frontend/domain/entities/stock_entity.dart';
import 'package:co_habit_frontend/domain/repositories/stock_repository.dart';

class GetAllStockUc {
  final StockRepository stockRepository;

  GetAllStockUc({required this.stockRepository});

  Future<List<StockEntity>> execute() async =>
      await stockRepository.getAllStock();
}
