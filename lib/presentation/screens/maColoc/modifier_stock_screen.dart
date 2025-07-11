import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/requests/requests.dart';
import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/controllers/stock_controller.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifierStockScreen extends StatefulWidget {
  final int stockId;
  const ModifierStockScreen({super.key, required this.stockId});

  @override
  State<ModifierStockScreen> createState() => _ModifierStockScreenState();
}

class _ModifierStockScreenState extends State<ModifierStockScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _capacityController;
  late Color _selectedColor;
  late StockModel _stock;
  late StockController _stockController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final stockProvider = context.read<StockProvider>();
    final stock = stockProvider.getStockById(widget.stockId);

    if (stock == null) {
      throw Exception('Stock non trouvé pour ID ${widget.stockId}');
    }

    final prefs = await SharedPreferences.getInstance();
    final colocId = prefs.getInt('foyerId');

    if (!mounted || colocId == null) return;

    _stockController = StockController(
      getAllStockUc: getIt<GetAllStockUc>(),
      updateStockUc: getIt<UpdateStockUc>(),
      getAllStockItemsUc: getIt<GetAllStockItemsUc>(),
      stockProvider: stockProvider,
      colocationId: colocId,
    );

    setState(() {
      _stock = stock;
      _nameController = TextEditingController(text: stock.title);
      _capacityController =
          TextEditingController(text: stock.maxCapacity.toString());
      _selectedColor = stock.color;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final request = StockRequest(
      title: _nameController.text.trim(),
      imageAsset: _stock.imageAsset,
      color: _selectedColor.toHexString(),
      maxCapacity:
          int.tryParse(_capacityController.text.trim()) ?? _stock.maxCapacity,
    );

    try {
      _stockController.updateStockLocally(request, _stock.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stock mis à jour avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la mise à jour'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir une couleur'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => setState(() => _selectedColor = color),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(title: 'Modifier le stock'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomFormField(
                        controller: _nameController,
                        label: 'Nom',
                        hintText: 'Entretien, Courses...',
                        validator: (value) =>
                            ValidationService.validateRequiredField(
                                value, 'le nom'),
                      ),
                      const SizedBox(height: 10),
                      CustomFormField(
                        controller: _capacityController,
                        label: 'Capacité maximale',
                        hintText: '200',
                        validator: (value) =>
                            ValidationService.validatePositiveNumbers(
                                value, 'capacité maximale'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Couleur: '),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _openColorPicker,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: _selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(width: 1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('#${_selectedColor.toHexString()}')
                        ],
                      ),
                      const SizedBox(height: 50),
                      CohabitButton(
                        text: 'Sauvegarder',
                        buttonType: ButtonType.gradient,
                        onPressed: _submitForm,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
