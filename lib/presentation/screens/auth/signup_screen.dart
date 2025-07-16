import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/usecases/auth/signup_usecase.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _dateNaissance;
  String? _selectedGender;
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dateNaissance) {
      setState(() {
        _dateNaissance = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _handleSignup() async {
    final signupUseCase = getIt<SignupUseCase>();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    final genderValidation = ValidationService.validateGender(_selectedGender);
    if (genderValidation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(genderValidation)),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await signupUseCase(
      RegisterData(
        username: _usernameController.text.trim(),
        fullName: '$firstName $lastName',
        firstName: firstName,
        lastName: lastName,
        birthDate: DateFormat('yyyy-MM-dd').format(_dateNaissance!),
        gender: _selectedGender!,
        phoneNumber: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      context.go('/login',
          extra: 'Inscription réussie, vous pouvez vous connecter !');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\'inscription a échoué...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const ScreenAppBar(title: 'Inscription'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildForm(),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CohabitButton(
                        text: 'S\'inscrire',
                        buttonType: ButtonType.gradient,
                        onPressed: _handleSignup,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        CustomFormField(
          controller: _usernameController,
          label: 'Nom d\'utilisateur',
          hintText: 'Voter nom d\'utilisateur',
          validator: (value) =>
              ValidationService.validateName('username', value),
        ),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _firstNameController,
          label: 'Votre prénom',
          validator: (value) => ValidationService.validateName('prénom', value),
        ),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _lastNameController,
          label: 'Nom',
          hintText: 'Votre nom',
          validator: (value) =>
              ValidationService.validateName('nom de famille', value),
        ),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _birthDateController,
          label: 'Date de naissance',
          hintText: 'Ex : 01/01/1970',
          readOnly: true,
          suffixIcon: IconButton(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today),
          ),
          validator: (_) => ValidationService.validateBirthDate(_dateNaissance),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Sexe',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Homme', child: Text('Homme')),
            DropdownMenuItem(value: 'Femme', child: Text('Femme')),
            DropdownMenuItem(
                value: 'Autre', child: Text('Autre / Je préfère ne pas dire')),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _phoneNumberController,
          label: 'Numéro de téléphone',
          hintText: 'Ex: 06 06 06 06 06',
          maxLength: 10,
          inputType: TextInputType.number,
          validator: (value) => ValidationService.validatePhoneNumber(value),
        ),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _emailController,
          label: 'Adresse e-mail',
          hintText: 'Ex: monMail@mail.com',
          inputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
