import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/controllers/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';

class EditStockItemDialog extends StatefulWidget {
  final StockItemModel item;
  final int stockId;

  const EditStockItemDialog(
      {super.key, required this.item, required this.stockId});

  @override
  State<EditStockItemDialog> createState() => _EditStockItemDialogState();
}

class _EditStockItemDialogState extends State<EditStockItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late StockController _stockController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());

    final colocId = Provider.of<FoyerProvider>(context, listen: false).colocId;

    _stockController = StockController(
      getAllStockUc: getIt(),
      getAllStockItemsUc: getIt(),
      updateStockItemUc: getIt(),
      deleteStockItemUc: getIt(),
      updateStockItemListUc: getIt(),
      updateStockUc: getIt(),
      stockProvider: context.read<StockProvider>(),
      colocationId: colocId!,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();
    final quantityStr = _quantityController.text.trim();
    final stock = context.read<StockProvider>().getStockById(widget.stockId);

    final validationError = ValidationService.validateMaxCapacity(
      quantityStr,
      'la quantité',
      stock?.maxCapacity ?? 999,
    );

    if (validationError != null) {
      setState(() => _errorText = validationError);
      return;
    }

    final newQuantity = int.parse(quantityStr);
    final request = StockItemRequest(name: newName, quantity: newQuantity);
    await _stockController.updateStockItemAlone(
        request, widget.stockId, widget.item.id);

    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text("Voulez-vous vraiment supprimer cet élément ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _stockController.deleteStockItem(
          _stockController.colocationId, widget.stockId, widget.item.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier l\'élément'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantité',
              errorText: _errorText,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleteItem,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Supprimer'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
