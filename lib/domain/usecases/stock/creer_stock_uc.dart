import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/stock_repository.dart';

class CreerStockUc {
  final StockRepository stockRepository;

  CreerStockUc({required this.stockRepository});

  Future<StockEntity> execute(StockModel stock) async =>
      await stockRepository.save(stock);
}
