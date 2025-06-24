import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class AddStockItemDialog extends StatelessWidget {
  final int stockId;
  final StockModel stock;
  final StockProvider stockProvider;

  const AddStockItemDialog({
    super.key,
    required this.stockId,
    required this.stock,
    required this.stockProvider,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final remainingCapacity = stock.maxCapacity - stock.itemCount;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              label: 'Quantité maximale',
              hintText: '9999',
              validator: (value) => ValidationService.validateMaxCapacity(
                  value, 'la quantité maximale', remainingCapacity),
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

                  stockProvider.addItemLocally(
                    stockId,
                    StockItemModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: name,
                      quantity: quantity,
                    ),
                  );

                  Navigator.pop(context);

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
  }
}
