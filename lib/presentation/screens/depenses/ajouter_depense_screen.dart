import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/depense_category_model.dart';
import 'package:co_habit_frontend/data/models/requests/depense_request.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/screens/depenses/controller/depenses_controller.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjouterDepenseScreen extends StatefulWidget {
  const AjouterDepenseScreen({super.key});

  @override
  State<AjouterDepenseScreen> createState() => _AjouterDepenseScreenState();
}

class _AjouterDepenseScreenState extends State<AjouterDepenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final DepensesController _depensesController;
  DepenseCategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final categories = context.read<DepensesProvider>().categories;
    if (categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }
    final colocationId = context.read<FoyerProvider>().colocId;
    if (colocationId != null) {
      _depensesController = DepensesController(
          getAllDepensesUc: getIt<GetAllDepensesUc>(),
          creerDepenseUc: getIt<CreerDepenseUc>(),
          depensesProvider: context.read<DepensesProvider>(),
          colocationId: colocationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<DepensesProvider>().categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle dépense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomFormField(
                controller: _titleController,
                label: 'Titre',
                hintText: 'Courses, Nettoyage, etc',
              ),
              CustomFormField(
                controller: _amountController,
                label: 'Montant (€)',
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<DepenseCategoryModel>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(_iconFromName(cat.icon)),
                              const SizedBox(width: 8),
                              Text(cat.label),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: 12),
              CustomFormField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) =>
                    ValidationService.validateDescriptionLength(value),
              ),
              const SizedBox(height: 30),
              CohabitButton(
                  text: 'Ajouter la dépense',
                  buttonType: ButtonType.gradient,
                  onPressed: _handleSubmit)
            ],
          ),
        ),
      ),
    );
  }

  DepenseRequest _buildFormRequest() {
    final colocationId = context.read<FoyerProvider>().colocId;
    final user = context.read<AuthProvider>().user;
    if (colocationId != null && user != null) {
      return DepenseRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          colocationId: colocationId,
          usersId: [user.id]);
    }
    throw Exception('[AjouterDepeseScreen] Id de la colocation manquant');
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final DepenseRequest request = _buildFormRequest();
      _depensesController.creerDepense(request, _selectedCategory!);
      Navigator.pop(context);
    }
  }

  IconData _iconFromName(String name) {
    const iconMap = {
      'shopping_cart': Icons.shopping_cart,
      'subscriptions': Icons.subscriptions,
      'commute': Icons.commute,
      'home': Icons.home,
      'receipt_long': Icons.receipt_long,
      'Home': Icons.home,
      'Commute': Icons.commute,
      'Receipts': Icons.receipt_long,
    };
    return iconMap[name] ?? Icons.category;
  }
}
