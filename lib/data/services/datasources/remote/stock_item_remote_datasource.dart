import 'dart:io';

import 'package:co_habit_frontend/data/models/models.dart';
import 'package:dio/dio.dart';

abstract class StockItemRemoteDatasource {
  Future<void> createItem(StockItemModel item);
  Future<void> deleteItem(StockItemModel item);
  Future<void> changeQuantity(int quantity, int id);
}

class StockItemRemoteDatasourceImpl implements StockItemRemoteDatasource {
  final Dio dio;

  StockItemRemoteDatasourceImpl({required this.dio});

  @override
  Future<void> changeQuantity(int quantity, int id) async {
    try {
      final response =
          await dio.post('/stockItems/changeQunatity', data: {quantity, id});

      if (response.statusCode == 200) {
        stderr.write('Changement avec succès');
      }
    } catch (e) {
      stderr.write('API error on changeQuantity: $e');
      rethrow;
    }
  }

  @override
  Future<void> createItem(StockItemModel item) async {
    try {
      final response = await dio.post('/stockItems/changeQunatity', data: item);

      if (response.statusCode == 200) {
        stderr.write('Création avec succès');
      }
    } catch (e) {
      stderr.write('API error on changeQuantity: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteItem(StockItemModel item) async {
    try {
      final response = await dio.post('/stockItems/changeQunatity', data: item);

      if (response.statusCode == 200) {
        stderr.write('Suppréssion avec succès');
      }
    } catch (e) {
      stderr.write('API error on changeQuantity: $e');
      rethrow;
    }
  }
}
