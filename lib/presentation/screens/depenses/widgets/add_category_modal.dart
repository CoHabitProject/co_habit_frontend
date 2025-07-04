import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/depense_category_model.dart';
import 'package:co_habit_frontend/presentation/providers/depenses_provider.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  String _selectedIcon = 'Home';

  void _initControllers() {
    _labelController = TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  static const availableIcons = {
    'Home': Icons.home,
    'Commute': Icons.commute,
    'Receipts': Icons.receipt_long,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle catégorie'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            const SizedBox(height: 10),
            CustomFormField(
              controller: _labelController,
              label: 'Nom de la catégorie',
              hintText: 'Alcohol, Entretien, etc',
              validator: (value) {
                final existingLabels = context
                    .read<DepensesProvider>()
                    .categories
                    .map((c) => c.label)
                    .toList();

                return ValidationService.validateCategoryName(
                    value, existingLabels);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedIcon,
              decoration: const InputDecoration(labelText: 'Icône'),
              items: availableIcons.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Row(
                          children: [
                            Icon(e.value),
                            const SizedBox(width: 8),
                            Text(e.key),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedIcon = val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<DepensesProvider>().addCategory(
                    DepenseCategoryModel(
                      label: _labelController.text.trim(),
                      icon: _selectedIcon,
                    ),
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
