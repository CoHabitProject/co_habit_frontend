import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/data/models/utilisateur_model.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UtilisateurModel? currentUser;
  bool isEditing = false;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    currentUser = authProvider.user;

    if (currentUser != null) {
      firstNameController = TextEditingController(text: currentUser!.firstName);
      lastNameController = TextEditingController(text: currentUser!.lastName);
      emailController = TextEditingController(text: currentUser!.email);
      phoneController = TextEditingController(text: currentUser!.phoneNumber);
      usernameController = TextEditingController(text: currentUser!.username);
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final updatedUser = UtilisateurModel(
      id: currentUser!.id,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      dateDeNaissance: currentUser!.dateDeNaissance,
      keyCloakSub: currentUser!.keyCloakSub,
      phoneNumber: phoneController.text,
      username: usernameController.text,
      fullName: '${firstNameController.text} ${lastNameController.text}',
      gender: currentUser!.gender,
      createdAt: currentUser!.createdAt,
      updatedAt: DateTime.now(),
    );

    authProvider.setUser(updatedUser);
    setState(() {
      currentUser = updatedUser;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: currentUser == null
          ? _buildUserNotFoundPage()
          : _buildUserInformation(currentUser!),
    );
  }

  Widget _buildUserNotFoundPage() {
    return const Center(
      child: Text('Erreur lors du chargement des informations utilisateur'),
    );
  }

  Widget _buildUserInformation(UtilisateurModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Text(
              user.initials,
              style: const TextStyle(fontSize: 42, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildFormField('Prénom', firstNameController, isEditing),
          _buildFormField('Nom', lastNameController, isEditing),
          _buildFormField('Email', emailController, false),
          _buildFormField('Téléphone', phoneController, isEditing),
          _buildFormField('Nom d\'utilisateur', usernameController, isEditing),
        ],
      ),
    );
  }

  Widget _buildFormField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        enabled: editable,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: !editable,
          fillColor: editable ? Colors.transparent : Colors.grey.shade100,
        ),
      ),
    );
  }
}
