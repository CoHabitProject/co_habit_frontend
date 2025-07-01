import 'dart:io';
import 'dart:ui';

import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/data/services/datasources/remote/stock_remote_datasource.dart';
import 'package:co_habit_frontend/domain/entities/stock_entity.dart';
import 'package:co_habit_frontend/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDatasource stockRemoteDatasource;

  StockRepositoryImpl({required this.stockRemoteDatasource});

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
      stderr.write('Repository Error on getLowestStock: $e');
      rethrow;
    }
  }

  @override
  Future<List<StockEntity>> getAllStock() async {
    try {
      return stockRemoteDatasource.getAllStock();
    } catch (e) {
      stderr.write('Repository Error on getAllStock: $e');
      rethrow;
    }
  }

  @override
  Future<StockEntity> updateStock(StockRequest request) async {
    try {
      return stockRemoteDatasource.updateStock(request);
    } catch (e) {
      stderr.write('Repository Error on updateStock : $e');
      rethrow;
    }
  }

  @override
  Future<StockEntity> save(StockRequest request, int colocationId) async {
    try {
      return stockRemoteDatasource.save(request, colocationId);
    } catch (e) {
      stderr.write('Repository Error on save: $e');
      rethrow;
    }
  }
}
