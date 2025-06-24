import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';
import 'package:flutter/material.dart';

class StockProvider with ChangeNotifier {
  final StockRepository stockRepository;

  StockProvider({required this.stockRepository});

  List<StockModel> _stock = [];

  List<StockModel> get stock => _stock;

  StockModel? getStockById(int id) {
    return _stock.firstWhere((s) => s.id == id);
  }

  void setStock(List<StockModel> stock) {
    _stock = stock;
    notifyListeners();
  }

  void updateItemQuantityLocally({
    required int stockId,
    required int itemId,
    required int newQuantity,
  }) {
    final stockIndex = _stock.indexWhere((s) => s.id == stockId);
    if (stockIndex == -1) return;

    final stock = _stock[stockIndex];
    final updatedItems = stock.items.map((item) {
      final StockItemModel itemModel = item as StockItemModel;
      if (itemModel.id == itemId) {
        return itemModel.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    _stock[stockIndex] = stock.copyWith(items: updatedItems);
    notifyListeners();
  }

  Future<void> persistStockUpdateAndReplace(StockModel updatedStock) async {
    await stockRepository.updateStock(updatedStock);
    _stock = [
      for (final s in _stock)
        if (s.id == updatedStock.id) updatedStock else s
    ];
    notifyListeners();
  }

  void addItemLocally(int stockId, StockItemModel newItem) {
    final stockIndex = _stock.indexWhere((s) => s.id == stockId);
    if (stockIndex == -1) return;

    final stock = _stock[stockIndex];
    final items = List<StockItemModel>.from(stock.items)..add(newItem);
    _stock[stockIndex] = stock.copyWith(items: items);
    notifyListeners();
  }

  void removeItemLocally(int stockId, int itemId) {
    final stockIndex = _stock.indexWhere((s) => s.id == stockId);
    if (stockIndex == -1) return;

    final stock = _stock[stockIndex];
    final items = stock.items.where((item) => item.id != itemId).toList();
    _stock[stockIndex] = stock.copyWith(items: items);
    notifyListeners();
  }

  void addStock(StockModel stock) {
    _stock.add(stock);
    notifyListeners();
  }
}
