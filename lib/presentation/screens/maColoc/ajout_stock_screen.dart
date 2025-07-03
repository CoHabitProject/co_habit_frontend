import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class AjoutStockScreen extends StatefulWidget {
  const AjoutStockScreen({super.key});

  @override
  State<AjoutStockScreen> createState() => _AjoutStockScreenState();
}

class _AjoutStockScreenState extends State<AjoutStockScreen> {
  final _formKey = GlobalKey<FormState>();
  Color color = AppTheme.darkPrimaryColor;

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _capacityController;

  void _initControllers() {
    _nameController = TextEditingController();
    _capacityController = TextEditingController();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _capacityController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeControllers();
  }

  bool _isFormValid() {
    return _formKey.currentState!.validate();
  }

  StockRequest _buildFormRequest() {
    return StockRequest(
        title: _nameController.text.trim(),
        imageAsset: 'assets/images/stock/autre.png',
        color: color.toHexString(),
        maxCapacity: int.parse(_capacityController.text.trim()));
  }

  Future<void> _submitForm() async {
    if (!_isFormValid()) return;

    final colocationId =
        Provider.of<FoyerProvider>(context, listen: false).colocId;

    try {
      final request = _buildFormRequest();
      final useCase = getIt<CreerStockUc>();
      final result = await useCase.execute(request, colocationId!);

      if (mounted) {
        final stockProvider =
            Provider.of<StockProvider>(context, listen: false);

        stockProvider.addStock(result as StockModel);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erreur dans la sauvegarde'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(title: 'Ajout type de stock'),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFormFields(),
                const SizedBox(
                  height: 50,
                ),
                CohabitButton(
                    text: 'Sauvegarder',
                    buttonType: ButtonType.gradient,
                    onPressed: _submitForm)
              ],
            )),
      )),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomFormField(
          controller: _nameController,
          label: 'Nom',
          hintText: 'Entretien,Courses...',
          validator: (value) =>
              ValidationService.validateRequiredField(value, 'le nom'),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomFormField(
          controller: _capacityController,
          label: 'Max capacity',
          hintText: '200',
          validator: (value) => ValidationService.validatePositiveNumbers(
              value, 'capacité maximale'),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text('Couleur: '),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: _openColorPicker,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text('#${color.toHexString()}')
          ],
        )
      ],
    );
  }

  void _openColorPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choisir une couleur'),
            content: SingleChildScrollView(
              child: ColorPicker(
                  pickerColor: color,
                  onColorChanged: (Color selectedColor) {
                    setState(() {
                      color = selectedColor;
                    });
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'))
            ],
          );
        });
  }
}
