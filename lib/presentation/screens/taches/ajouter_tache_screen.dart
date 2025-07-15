import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/tache_category_model.dart';
import 'package:co_habit_frontend/domain/usecases/taches/create_tache_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_all_taches_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_tache_by_id_uc.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/providers/taches_provider.dart';
import 'package:co_habit_frontend/presentation/screens/taches/controller/taches_controller.dart';
import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjouterTacheScreen extends StatefulWidget {
  const AjouterTacheScreen({super.key});

  @override
  State<AjouterTacheScreen> createState() => _AjouterTacheScreenState();
}

class _AjouterTacheScreenState extends State<AjouterTacheScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final TachesController _TachesController;
  TacheCategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final categories = context.read<TachesProvider>().categories;
    if (categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }
    final colocationId = context.read<FoyerProvider>().colocId;
    if (colocationId != null) {
      _TachesController = TachesController(
          creerTacheUC: getIt<CreerTacheUc>(),
          getAllTachesUC: getIt<GetAllTachesUc>(),
          getLastCreatedTachesUc: getIt<GetLastCreatedTachesUc>(),
          getTacheByIdUC: getIt<GetTacheByIdUc>(),
          tachesProvider: context.read<TachesProvider>(),
          colocationId: colocationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<TachesProvider>().categories;

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
              DropdownButtonFormField<TacheCategoryModel>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: categories
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(_iconFromName(cat.label)),
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

  TacheModel _buildFormRequest() {
    final colocationId = context.read<FoyerProvider>().colocId;
    final user = context.read<AuthProvider>().user;
    if (colocationId != null && user != null) {
      return TacheModel(
          id: 1,
          firstName: 'firstName',
          lastName: 'lastName',
          title: 'title',
          category: 'category',
          date: DateTime(1970,01,01),
          status: TacheStatus.enAttente
          // title: _titleController.text.trim(),
          // description: _descriptionController.text.trim(),
          // amount: double.parse(_amountController.text.trim()),
          // colocationId: colocationId,
          // usersId: [user.id]);
      );
    }
    throw Exception('[AjouterDepeseScreen] Id de la colocation manquant');
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final TacheModel model = _buildFormRequest();
      _TachesController.creerTache(model/*, _selectedCategory!*/);
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
