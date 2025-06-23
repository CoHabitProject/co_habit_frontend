import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/stock_item_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockDetailScreen extends StatefulWidget {
  final int stockId;
  const StockDetailScreen({super.key, required this.stockId});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  bool _isBottomSheetOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<FloatingNavbarController>().setActionForRoute(
      '/maColoc/stock/${widget.stockId}',
      () {
        showBottomMenu(context, [
          ListTile(
            title: const Text('Ajouter un élément',
                style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              _showAddItemDialog(context);
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

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ajouter un élément',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: nameController,
                  label: 'Nom',
                  hintText: 'Mouchoir, Papier toilette...',
                  validator: (value) => ValidationService.validateRequiredField(
                      value, 'le nom de l\'élément'),
                ),
                const SizedBox(height: 12),
                CustomFormField(
                  controller: quantityController,
                  label: 'Quantité',
                  hintText: '9999',
                  validator: (value) =>
                      ValidationService.validatePositiveNumbers(
                          value, 'la quantité'),
                ),
                const SizedBox(height: 24),
                CohabitButton(
                  text: 'Valider',
                  buttonType: ButtonType.gradient,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final quantity =
                          int.tryParse(quantityController.text.trim()) ?? 1;

                      final provider =
                          Provider.of<StockProvider>(context, listen: false);

                      provider.addItemLocally(
                        widget.stockId,
                        StockItemModel(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: name,
                          quantity: quantity,
                        ),
                      );

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '"$name" ajouté avec succès ',
                            style: const TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          backgroundColor: const Color(0xFF2E7D32),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StockProvider>();
    final stock = context.watch<StockProvider>().getStockById(widget.stockId);
    return Scaffold(
      appBar: ScreenAppBar(title: stock!.title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              Text(
                '${stock.itemCount} éléments',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ...stock.items.map(
                (item) => StockItemCard(
                  item: item as StockItemModel,
                  onIncrement: () {
                    provider.updateItemQuantityLocally(
                      stockId: stock.id,
                      itemId: item.id,
                      newQuantity: item.quantity + 1,
                    );
                  },
                  onDecrement: () {
                    if (item.quantity == 1) {
                      provider.removeItemLocally(stock.id, item.id);
                    } else {
                      provider.updateItemQuantityLocally(
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
    );
  }
}
