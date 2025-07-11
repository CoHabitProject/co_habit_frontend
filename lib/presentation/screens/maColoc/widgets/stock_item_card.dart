import 'package:co_habit_frontend/data/models/stock_item_model.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/edit_stock_item_dialog.dart';
import 'package:flutter/material.dart';

class StockItemCard extends StatelessWidget {
  final StockItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isFull;
  final int stockId;

  const StockItemCard(
      {super.key,
      required this.item,
      required this.onIncrement,
      required this.onDecrement,
      required this.isFull,
      required this.stockId});

  @override
  Widget build(BuildContext context) {
    final isLast = item.quantity == 1;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isLast
              ? const BorderSide(color: Colors.red, width: 2)
              : BorderSide.none),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              color: Colors.indigo,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            )),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => EditStockItemDialog(
                              item: item, stockId: stockId));
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                    )),
                IconButton(
                  onPressed: onDecrement,
                  icon: Icon(isLast
                      ? Icons.delete_outline
                      : Icons.remove_circle_outline_rounded),
                  color: isLast ? Colors.red : null,
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: isFull ? null : onIncrement,
                  icon: const Icon(Icons.add_circle_outline),
                  color: isFull ? Colors.transparent : null,
                  disabledColor: Colors.transparent,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
