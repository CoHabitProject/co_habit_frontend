import 'package:co_habit_frontend/domain/entities/stock_entity.dart';
import 'package:co_habit_frontend/domain/repositories/stock_repository.dart';

class GetLowestStockUc {
  final StockRepository stockRepository;

  GetLowestStockUc({required this.stockRepository});

  Future<List<StockEntity>> execute() async => stockRepository.getLowestStock();
}
