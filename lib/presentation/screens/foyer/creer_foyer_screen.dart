import 'dart:io';

import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_form_field.dart';
import 'package:co_habit_frontend/presentation/widgets/common/screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late final TextEditingController _nbPersonnesController;
  late final TextEditingController _dateEntreeController;

  DateTime? _dateEntree;

  void _initControllers() {
    _nameController = TextEditingController();
    _villeController = TextEditingController();
    _adresseController = TextEditingController();
    _codePostalController = TextEditingController();
    _nbPersonnesController = TextEditingController();
    _dateEntreeController = TextEditingController();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _villeController.dispose();
    _adresseController.dispose();
    _codePostalController.dispose();
    _nbPersonnesController.dispose();
    _dateEntreeController.dispose();
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
    return _formKey.currentState!.validate() &&
        ValidationService.validateDateField(_dateEntree) == null;
  }

  FoyerModel _buildFormData() {
    return FoyerModel(
        id: 0,
        name: _nameController.text.trim(),
        ville: _villeController.text.trim(),
        adresse: _adresseController.text.trim(),
        codePostal: _codePostalController.text.trim(),
        nbPersonnes: int.parse(_nbPersonnesController.text.trim()),
        dateEntree: DateFormat('dd-MM-yyyy').format(_dateEntree!),
        code: '38256',
        membres: []);
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
      final formData = _buildFormData();
      final useCase = getIt<CreerFoyerUseCase>();
      final result = await useCase.execute(formData);

      if (mounted) {
        // sauvegarde dans provider TODO : supprimmer
        stderr.write(result);
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Une erreur est survenue');
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (picked != null && picked != _dateEntree) {
      setState(() {
        _dateEntree = picked;
        _dateEntreeController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
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
        _buildDateField()
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      children: [
        CustomFormField(
          controller: _dateEntreeController,
          label: 'Date d\'entrée',
          hintText: '12/12/2024',
          readOnly: true,
          suffixIcon: IconButton(
              onPressed: _selectDate, icon: const Icon(Icons.calendar_today)),
          validator: (_) => ValidationService.validateDateField(_dateEntree),
        ),
      ],
    );
  }
}
