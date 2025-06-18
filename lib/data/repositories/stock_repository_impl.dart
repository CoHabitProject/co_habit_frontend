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
            imageAsset: 'assets/images/tasks/soap.png'),
        StockModel(
            id: 2,
            title: 'Entretien',
            itemCount: 8,
            totalItems: 16,
            color: const Color(0xFFFF993A),
            imageAsset: 'assets/images/tasks/broom.png')
      ];
    } catch (e) {
      stderr.write('Repository Error on getLowestStock: $e');
      rethrow;
    }
  }
}
