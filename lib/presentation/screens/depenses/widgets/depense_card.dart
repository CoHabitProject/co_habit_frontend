import 'package:flutter/material.dart';
import 'package:co_habit_frontend/data/models/depense_model.dart';

class ExpenseCard extends StatelessWidget {
  final DepenseModel depense;
  final VoidCallback? onTap;

  const ExpenseCard({
    super.key,
    required this.depense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final payerInitials = _getInitials(depense.user.initials);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                payerInitials,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                depense.title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              '€ ${depense.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
