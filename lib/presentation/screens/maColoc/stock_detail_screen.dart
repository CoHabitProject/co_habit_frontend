import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/controllers/stock_controller.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/add_stock_item_dialog.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/stock_item_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StockDetailScreen extends StatefulWidget {
  final int stockId;
  const StockDetailScreen({super.key, required this.stockId});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  bool _isBottomSheetOpen = false;
  late final StockController _stockController;

  void _initController(int colocationId) {
    _stockController = StockController(
        getAllStockUc: getIt<GetAllStockUc>(),
        getAllStockItemsUc: getIt<GetAllStockItemsUc>(),
        stockProvider: context.read<StockProvider>(),
        updateStockItemListUc: getIt<UpdateStockItemListUc>(),
        deleteStockItemUc: getIt<DeleteStockItemUc>(),
        colocationId: colocationId);
  }

  bool _controllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_controllerInitialized) {
      final colocationId = context.read<FoyerProvider>().colocId;
      if (colocationId == null) {
        throw Exception('[StockDetailScreen] Erreur : colocationId manquant');
      }
      _initController(colocationId);
      _controllerInitialized = true;
    }

    final stockProvider = context.read<StockProvider>();
    final stock = stockProvider.getStockById(widget.stockId)!;

    context.read<FloatingNavbarController>().setActionForRoute(
      '/maColoc/stock/${widget.stockId}',
      () {
        showBottomMenu(context, [
          ListTile(
            title: const Text('Ajouter un élément',
                style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (ctx) => AddStockItemDialog(
                  stockId: widget.stockId,
                  stock: stock,
                  stockProvider: stockProvider,
                ),
              );
            },
          ),
        ]);
      },
    );
  }

  void showBottomMenu(BuildContext context, List<ListTile> actions) {
    if (_isBottomSheetOpen || !mounted) return;
    _isBottomSheetOpen = true;

    showCustomActionSheet(
      context: context,
      title: 'Ajouter un élément',
      subTitle: 'Vous pouvez ajouter un élément à ce type de stock',
      actions: actions,
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _isBottomSheetOpen = false;
        });
      }
    });
  }

  Widget _buildWarningMessage() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA000)),
          SizedBox(width: 8),
          Text(
            'Capacité maximale atteinte !',
            style: TextStyle(
              color: Color(0xFFEF6C00),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = context.read<StockProvider>();
    final stock = context.watch<StockProvider>().getStockById(widget.stockId)!;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        await _stockController.persistPendingItemUpdates(widget.stockId);
        if (mounted) navigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: ScreenAppBar(
          title: stock.title,
          actions: [
            IconButton(
                onPressed: () {
                  context.push(('/stock/${stock.id}/edit'));
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                Text(
                  '${stock.itemCount} éléments de ${stock.maxCapacity}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                ),
                const SizedBox(height: 20),
                if (stock.isFull) _buildWarningMessage(),
                const SizedBox(height: 20),
                ...stock.items.map(
                  (item) => StockItemCard(
                    item: item as StockItemModel,
                    isFull: stock.isFull,
                    onIncrement: () {
                      stockProvider.updateItemQuantityLocally(
                        stockId: stock.id,
                        itemId: item.id,
                        newQuantity: item.quantity + 1,
                      );
                    },
                    onDecrement: () {
                      if (item.quantity == 1) {
                        stockProvider.removeItemLocally(stock.id, item.id);
                      } else {
                        stockProvider.updateItemQuantityLocally(
                          stockId: stock.id,
                          itemId: item.id,
                          newQuantity: item.quantity - 1,
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
