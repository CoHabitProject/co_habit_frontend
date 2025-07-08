import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/screens/auth/widgets/social_login_button.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';

class LoginScreen extends StatefulWidget {
  final String? initialMessage;
  const LoginScreen({super.key, this.initialMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final foyerProvider = Provider.of<FoyerProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text.trim(),
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
        } catch (_) {
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
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildTitle(),
                          const SizedBox(height: 24),
                          SizedBox(
                              height: 180,
                              child: Lottie.network(
                                  'https://lottie.host/362be1e0-c892-46b7-aadf-f9c5bbb4b9a2/rYlurhfasK.json',
                                  height: 290)),
                          const SizedBox(height: 24),
                          _buildLoginForm(),
                          const SizedBox(height: 12),
                          const Divider(height: 20, thickness: 1),
                          const SizedBox(height: 10),
                          const SocialLoginButton(
                            icon: Icons.facebook_outlined,
                            label: 'Continuer avec Facebook',
                          ),
                          const SizedBox(height: 12),
                          const SocialLoginButton(
                            icon: Icons.g_mobiledata_outlined,
                            label: 'Continuer avec Google',
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 15),
                          const Text(
                            "Vous n'avez pas de compte ?",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () => context.push('/signup'),
                            child: const Text(
                              'Inscrivez-vous',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text.rich(
      TextSpan(
        text: 'Bienvenue à ',
        style: TextStyle(fontSize: 27),
        children: [
          TextSpan(
              text: 'CoHabit', style: TextStyle(color: AppTheme.primaryColor)),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Adresse e-mail',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
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
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : CohabitButton(
                text: 'Connexion',
                buttonType: ButtonType.gradient,
                onPressed: _handleLogin,
              ),
      ],
    );
  }
}
