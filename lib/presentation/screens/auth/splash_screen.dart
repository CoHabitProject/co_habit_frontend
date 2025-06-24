import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // On attend que initAuth se termine (normalement lancé dans main)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Attente active du flag d'initialisation
      while (!authProvider.isInitialized) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Redirection
      if (mounted) {
        if (authProvider.isAuthenticated) {
          context.go('/choixInitial');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ou AppTheme.primaryColor
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/onboarding/logo_white.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Un foyer organisé, enfin.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
