import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';

class StockController {
  final GetAllStockUc getAllStockUc;
  final GetAllStockItemsUc getAllStockItemsUc;
  final UpdateStockItemListUc? updateStockItemListUc;
  final DeleteStockItemUc? deleteStockItemUc;
  final StockProvider stockProvider;
  final int colocationId;

  StockController({
    required this.getAllStockUc,
    required this.getAllStockItemsUc,
    this.updateStockItemListUc,
    this.deleteStockItemUc,
    required this.stockProvider,
    required this.colocationId,
  });

  Future<void> loadAllStocksAndItems() async {
    final stocks = await getAllStockUc.execute(colocationId);
    final stockList = stocks.whereType<StockModel>().toList();
    stockProvider.setStock(stockList);

    for (final stock in stockList) {
      final items = await getAllStockItemsUc.execute(colocationId, stock.id);
      for (final item in items) {
        stockProvider.addItemLocally(stock.id, item as StockItemModel);
      }
    }
  }

  Future<void> persistPendingItemUpdates(int stockId) async {
    final updates = stockProvider.pendingItemUpdates;
    final deletions = stockProvider.itemsToDelete;

    if (updates.isNotEmpty) {
      if (updateStockItemListUc == null) {
        throw Exception("GetFoyerByCodeUc non initialisé");
      }
      await updateStockItemListUc!.execute(updates, colocationId, stockId);
      stockProvider.clearPendingUpdates();
    }

    if (deletions.isNotEmpty) {
      if (deleteStockItemUc == null) {
        throw Exception('DeleteStockItemUc non intialisé');
      }
      for (final itemId in deletions.keys) {
        await deleteStockItemUc!.execute(colocationId, stockId, itemId);
      }
      stockProvider.clearItemsToDelete();
    }
  }

  Future<List<StockModel>> getLowestStock() async {
    await loadAllStocksAndItems();
    final stock = stockProvider.stock;

    // Filtrer ceux à moins de 50%
    final lowStock = stock.where((s) => s.itemCountPercentage < 0.5).toList();

    // Trier par ordre croissant
    lowStock
        .sort((a, b) => a.itemCountPercentage.compareTo(b.itemCountPercentage));

    // Retourner les 2 plus bas
    return lowStock.take(2).toList();
  }
}
