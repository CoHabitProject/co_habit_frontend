import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/validation_service.dart';
import 'package:co_habit_frontend/domain/entities/register_data.dart';
import 'package:co_habit_frontend/domain/usecases/auth/signup_usecase.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_form_field.dart';
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
  bool _isLoading = false;

  // Stockage des éléments sélectionnés dans le formulaire
  DateTime? _dateNaissance;
  String? _selectedGender;

  Future<void> _handleSignup() async {
    final signupUseCase = getIt<SignupUseCase>();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String fullName = '$firstName $lastName';

    final String? genderIsValid =
        ValidationService.validateGender(_selectedGender);
    if (genderIsValid != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(genderIsValid)),
      );
      return;
    }

    final success = await signupUseCase(
      RegisterData(
        username: _usernameController.text.trim(),
        fullName: fullName,
        firstName: firstName,
        lastName: lastName,
        // La date est stockée au format dd/MM/yyyy pour l'affichage user, mais l'api le veut au format yyyy-MM-dd donc on doit la formatter ici.
        birthDate: DateFormat('yyyy-MM-dd').format(_dateNaissance!),
        gender:
            _selectedGender!, // Si on arrive ici c'est que le selectedGender n'est pas null !
        phoneNumber: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        context.go('/login',
            extra: 'Inscription réussie, vous pouvez vous connecter !');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'inscription a échoué...')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(1900), lastDate: DateTime.now());

    if (picked != null && picked != _dateNaissance) {
      setState(() {
        _dateNaissance = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          CustomFormField(
            controller: _usernameController,
            label: 'Nom d\'utilisateur',
            validator: (value) =>
                ValidationService.validateName('username', value),
            inputType: TextInputType.text,
          ),
          CustomFormField(
              controller: _firstNameController,
              label: 'Prénom',
              validator: (value) =>
                  ValidationService.validateName('prénom', value),
              inputType: TextInputType.text),
          CustomFormField(
            controller: _lastNameController,
            label: 'Nom',
            validator: (value) =>
                ValidationService.validateName('nom de famille', value),
            inputType: TextInputType.text,
          ),
          CustomFormField(
            controller: _birthDateController,
            label: 'Date de naissance',
            hintText: '01/01/1970',
            readOnly: true,
            suffixIcon: IconButton(
                onPressed: _selectDate, icon: const Icon(Icons.calendar_today)),
            validator: (_) =>
                ValidationService.validateBirthDate(_dateNaissance),
          ),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            items: const [
              DropdownMenuItem(value: 'Homme', child: Text('Homme')),
              DropdownMenuItem(value: 'Femme', child: Text('Femme')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Sexe'),
          ),
          CustomFormField(
            controller: _phoneNumberController,
            label: 'Numéro de téléphone',
            maxLength: 10,
            validator: (value) => ValidationService.validatePhoneNumber(value),
            inputType: TextInputType.number,
          ),
          CustomFormField(
            controller: _emailController,
            label: 'Adresse e-mail',
            inputType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Mot de passe'),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _handleSignup,
                  child: const Text(
                    'S\'inscrire',
                  ),
                ),
          TextButton(
              onPressed: () => context.go('/login'),
              child: const Text(
                  'Vous avez déjà un compte ? Connectez-vous ici !')),
        ]),
      ),
    );
  }
}
