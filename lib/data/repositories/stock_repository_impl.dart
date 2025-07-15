import 'dart:ui';

import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/stock_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/stock_entity.dart';
import 'package:co_habit_frontend/domain/repositories/stock_repository.dart';
import 'package:get_it/get_it.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDatasource stockRemoteDatasource;

  StockRepositoryImpl({required this.stockRemoteDatasource});

  final _log = GetIt.instance<LogService>();

  @override
  Future<List<StockEntity>> getLowestStock() async {
    try {
      // return await stockRemoteDatasource.getLowestStock();
      return [
        StockModel(
            id: 1,
            title: 'Hygiène',
            color: const Color(0xFF369FFF),
            imageAsset: 'assets/images/stock/soap.png',
            items: [
              StockItemModel(id: 1, name: 'Savon', quantity: 3),
              StockItemModel(id: 2, name: 'Shampoing', quantity: 2),
              StockItemModel(id: 3, name: 'Dentifrice', quantity: 1),
            ],
            maxCapacity: 20),
        StockModel(
            id: 2,
            title: 'Entretien',
            color: const Color(0xFFFF993A),
            imageAsset: 'assets/images/stock/broom.png',
            items: [
              StockItemModel(id: 1, name: 'Balai', quantity: 2),
              StockItemModel(id: 2, name: 'Éponge', quantity: 3),
              StockItemModel(id: 3, name: 'Produit sol', quantity: 2),
              StockItemModel(id: 4, name: 'Liquide vaisselle', quantity: 1),
            ],
            maxCapacity: 30),
      ];
    } catch (e) {
      _log.error('Repository Error on getLowestStock: $e');
      rethrow;
    }
  }

  @override
  Future<List<StockEntity>> getAllStock(int colocationId) async {
    try {
      return stockRemoteDatasource.getAllStock(colocationId);
    } catch (e) {
      _log.error('Repository Error on getAllStock: $e');
      rethrow;
    }
  }

  @override
  Future<StockEntity> save(StockRequest request, int colocationId) async {
    try {
      return await stockRemoteDatasource.save(request, colocationId);
    } catch (e) {
      _log.error('Repository Error on save: $e');
      rethrow;
    }
  }

  @override
  Future<StockEntity> updateStock(
      StockRequest stock, int stockId, int colocationId) async {
    try {
      return await stockRemoteDatasource.updateStock(
          stock, stockId, colocationId);
    } catch (e, stack) {
      _log.error('[StockRepositoryImpl] API Error on updateStock: $e',
          stackTrace: stack);
      rethrow;
    }
  }
}
