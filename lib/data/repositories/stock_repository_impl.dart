import 'dart:io';
import 'dart:ui';

import 'package:co_habit_frontend/data/models/models.dart';
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
      // return stockRemoteDatasource.getAllStock();
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
        StockModel(
            id: 3,
            title: 'Courses',
            color: const Color(0xFF8AC53E),
            imageAsset: 'assets/images/stock/courses.png',
            items: [
              StockItemModel(id: 1, name: 'Pâtes', quantity: 5),
              StockItemModel(id: 2, name: 'Riz', quantity: 2),
              StockItemModel(id: 3, name: 'Lait', quantity: 3),
              StockItemModel(id: 4, name: 'Café', quantity: 1),
            ],
            maxCapacity: 100),
        StockModel(
            id: 4,
            title: 'Autres',
            color: const Color(0xFFAF52DE),
            imageAsset: 'assets/images/stock/autre.png',
            items: [
              StockItemModel(id: 1, name: 'Sac poubelle', quantity: 6),
              StockItemModel(id: 2, name: 'Papier aluminium', quantity: 2),
              StockItemModel(id: 3, name: 'Film plastique', quantity: 2),
            ],
            maxCapacity: 100),
      ];
    } catch (e) {
      stderr.write('Repository Error on getAllStock: $e');
      rethrow;
    }
  }

  @override
  Future<StockEntity> updateStock(StockModel stock) async {
    try {
      return stockRemoteDatasource.updateStock(stock);
    } catch (e) {
      stderr.write('Repository Error on updateStock : $e');
      rethrow;
    }
  }
}
