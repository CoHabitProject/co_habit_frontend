import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/screens/foyer/controller/foyer_controller.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_form_field.dart';
import 'package:co_habit_frontend/presentation/widgets/common/screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreerFoyerScreen extends StatefulWidget {
  const CreerFoyerScreen({super.key});

  @override
  State<CreerFoyerScreen> createState() => _CreerFoyerScreenState();
}

class _CreerFoyerScreenState extends State<CreerFoyerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _villeController;
  late final TextEditingController _adresseController;
  late final TextEditingController _codePostalController;
  late final FoyerController _creerFoyerController;

  void _initControllers() {
    _nameController = TextEditingController();
    _villeController = TextEditingController();
    _adresseController = TextEditingController();
    _codePostalController = TextEditingController();
    _creerFoyerController = FoyerController(
        creerFoyerUc: getIt<CreerFoyerUseCase>(),
        creerStockUc: getIt<CreerStockUc>(),
        foyerProvider: context.read<FoyerProvider>(),
        stockProvider: context.read<StockProvider>());
  }

  void _disposeControllers() {
    _nameController.dispose();
    _villeController.dispose();
    _adresseController.dispose();
    _codePostalController.dispose();
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

  CreerFoyerRequest _buildFormData() {
    return CreerFoyerRequest(
        name: _nameController.text.trim(),
        adresse: _adresseController.text.trim(),
        ville: _villeController.text.trim(),
        codePostal: _codePostalController.text.trim());
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> _submitForm() async {
    if (!_isFormValid()) {
      return;
    }

    try {
      final request = _buildFormData();
      await _creerFoyerController.creerFoyerEtStocks(request);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(
            '[CreerFoyerScreen] Une erreur est survenue lors de la créatio du foyer : ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const ScreenAppBar(title: 'Création du foyer'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFormFields(),
                const SizedBox(height: 30),
                CohabitButton(
                    text: 'Créer le foyer',
                    buttonType: ButtonType.gradient,
                    onPressed: _submitForm)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomFormField(
          controller: _nameController,
          label: 'Nom du foyer',
          hintText: 'Le nom du foyer à créer',
          validator: (value) =>
              ValidationService.validateRequiredField(value, 'un nom'),
        ),
        CustomFormField(
          controller: _villeController,
          label: 'Ville',
          hintText: 'La ville du foyer (ex: Lyon)',
          validator: (value) =>
              ValidationService.validateRequiredField(value, 'une ville'),
        ),
        CustomFormField(
          controller: _adresseController,
          label: 'Adresse',
          hintText: 'L\'adresse du foyer',
          validator: (value) =>
              ValidationService.validateRequiredField(value, 'une adresse'),
        ),
        CustomFormField(
          controller: _codePostalController,
          label: 'Code postal',
          hintText: 'Le code postal (ex: 69000)',
          maxLength: 5,
          validator: (value) =>
              ValidationService.validateCodePostalField(value),
          inputType: TextInputType.number,
        ),
      ],
    );
  }
}
