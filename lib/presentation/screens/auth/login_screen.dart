import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String? initialMessage;
  const LoginScreen({super.key, this.initialMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final foyerProvider = Provider.of<FoyerProvider>(context, listen: false);

    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      final foyerId = prefs.getInt('foyerId');

      if (foyerId != null) {
        try {
          final foyer = await getIt<GetFoyerByIdUc>().execute(foyerId);
          foyerProvider.setFoyer(foyer as FoyerModel);
          if (mounted) context.go('/home');
        } catch (e) {
          // Si erreur (foyer supprimé, etc.), aller quand même à choixInitial
          if (mounted) context.go('/choixInitial');
        }
      } else {
        if (mounted) context.go('/choixInitial');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La connexion a échoué')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.initialMessage!)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
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
                  onPressed: _handleLogin,
                  child: const Text('Connexion'),
                ),
          TextButton(
            onPressed: () {
              context.go('/signup');
            },
            child: const Text('Pas encore de compte ? Inscrivez-vous ici.'),
          ),
        ]),
      ),
    );
  }
}
