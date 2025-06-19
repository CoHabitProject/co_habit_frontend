import 'dart:io';
import 'dart:ui';

import 'package:co_habit_frontend/data/models/stock_model.dart';
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
            itemCount: 3,
            totalItems: 10,
            color: const Color(0xFF369FFF),
            imageAsset: 'assets/images/stock/soap.png'),
        StockModel(
            id: 2,
            title: 'Entretien',
            itemCount: 8,
            totalItems: 16,
            color: const Color(0xFFFF993A),
            imageAsset: 'assets/images/stock/broom.png')
      ];
    } catch (e) {
      stderr.write('Repository Error on getLowestStock: $e');
      rethrow;
    }
  }

  @override
  Future<List<StockEntity>> getAllStock() async {
    try {
      // return await stockRemoteDatasource.getAllStock();
      return [
        StockModel(
            id: 1,
            title: 'Hygiène',
            itemCount: 3,
            totalItems: 10,
            color: const Color(0xFF369FFF),
            imageAsset: 'assets/images/stock/soap.png'),
        StockModel(
            id: 2,
            title: 'Entretien',
            itemCount: 8,
            totalItems: 16,
            color: const Color(0xFFFF993A),
            imageAsset: 'assets/images/stock/broom.png'),
        StockModel(
            id: 3,
            title: 'Courses',
            itemCount: 20,
            totalItems: 22,
            color: const Color(0xFF8AC53E),
            imageAsset: 'assets/images/stock/courses.png'),
        StockModel(
            id: 4,
            title: 'Autres',
            itemCount: 20,
            totalItems: 20,
            color: const Color(0xFFAF52DE),
            imageAsset: 'assets/images/stock/autre.png'),
      ];
    } catch (e) {
      stderr.write('Repository Error on getAllStock: $e');
      rethrow;
    }
  }
}
