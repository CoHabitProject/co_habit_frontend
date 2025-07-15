import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/requests/stock_item_request.dart';
import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/domain/usecases/stock/creer_stock_item_uc.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AddStockItemDialog extends StatelessWidget {
  final int stockId;
  final StockModel stock;
  final StockProvider stockProvider;

  final _log = GetIt.instance<LogService>();

  AddStockItemDialog({
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

    Future<void> onSubmitForm() async {
      if (formKey.currentState!.validate()) {
        try {
          final StockItemRequest request = StockItemRequest(
              name: nameController.text.trim(),
              quantity: int.parse(quantityController.text.trim()));

          final colocationId =
              Provider.of<FoyerProvider>(context, listen: false).colocId;

          if (colocationId != null) {
            final useCase = getIt<CreerStockItemUc>();
            final result =
                await useCase.execute(colocationId, stockId, request);
            stockProvider.addItemLocally(stockId, result as StockItemModel);

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Item ajouté avec succès ',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            }
          }
        } catch (e, stack) {
          _log.error('[AddStockItemDialog] Error dans l\'ajout d\'un item: $e',
              stackTrace: stack);
        }
      }
    }

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
              onPressed: onSubmitForm,
            )
          ],
        ),
      ),
    );
  }
}
