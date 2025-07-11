import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';
import 'package:flutter/material.dart';

class StockProvider with ChangeNotifier {
  final StockRepository stockRepository;

  StockProvider({required this.stockRepository});

  List<StockModel> _stock = [];

  final Map<int, StockItemRequest> _pendingItemUpdates = {};
  final Map<int, bool> _itemsToDelete = {};

  // Getter pending items to update
  Map<int, StockItemRequest> get pendingItemUpdates =>
      Map.unmodifiable(_pendingItemUpdates);

  void clearPendingUpdates() => _pendingItemUpdates.clear();

  // Getter des items à supprimer
  Map<int, bool> get itemsToDelete => Map.unmodifiable(_itemsToDelete);

  void clearItemsToDelete() => _itemsToDelete.clear();

  // Getter du stock
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
        // on sauvegarde l'id et l'item modifiée pour ensuite faire la mise à jour en BDD
        _pendingItemUpdates[itemId] =
            StockItemRequest(name: itemModel.name, quantity: newQuantity);
        return itemModel.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    _stock[stockIndex] = stock.copyWith(items: updatedItems);
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

    // On set dans la map le boolean a true pour faire la suppression en bdd
    _itemsToDelete[itemId] = true;

    final stock = _stock[stockIndex];
    final items = stock.items.where((item) => item.id != itemId).toList();
    _stock[stockIndex] = stock.copyWith(items: items);
    notifyListeners();
  }

  void addStock(StockModel stock) {
    _stock.add(stock);
    notifyListeners();
  }

  void updateStockLocally(StockModel updatedStock) {
    final index = _stock.indexWhere((s) => s.id == updatedStock.id);
    if (index == -1) return;

    final currentItems = _stock[index].items;

    // fusionne avec les items existants si non fournis
    _stock[index] = updatedStock.copyWith(items: currentItems);
    notifyListeners();
  }
}
