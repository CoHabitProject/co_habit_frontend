import 'dart:io';

import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/data/services/datasources/datasources.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class StockItemRepositoryImpl implements StockItemRepository {
  final StockItemRemoteDatasource remoteDatasource;

  StockItemRepositoryImpl({required this.remoteDatasource});

  @override
  Future<void> changeQuantity(int quantity, int id) async {
    try {
      return await remoteDatasource.changeQuantity(quantity, id);
    } catch (e) {
      stderr.write('Repository error on changeQuantity: $e');
    }
  }

  @override
  Future<void> createItem(StockItemModel item) async {
    try {
      return await remoteDatasource.createItem(item);
    } catch (e) {
      stderr.write('Repository error on createItem: $e');
    }
  }

  @override
  Future<void> deleteItem(StockItemModel item) async {
    try {
      return await remoteDatasource.deleteItem(item);
    } catch (e) {
      stderr.write('Repository error on deleteItem: $e');
    }
  }
}
