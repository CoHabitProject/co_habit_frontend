import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/domain/usecases/foyer/creer_foyer_usecase.dart';
import 'package:co_habit_frontend/domain/usecases/foyer/get_foyer_by_id_uc.dart';
import 'package:co_habit_frontend/domain/usecases/stock/creer_stock_uc.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:co_habit_frontend/presentation/providers/stock_provider.dart';
import 'package:co_habit_frontend/presentation/screens/foyer/controller/foyer_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final FoyerController _foyerController;

  @override
  void initState() {
    super.initState();

    _foyerController = FoyerController(
        getFoyerByIdUc: getIt<GetFoyerByIdUc>(),
        creerFoyerUc: getIt<CreerFoyerUseCase>(),
        creerStockUc: getIt<CreerStockUc>(),
        foyerProvider: context.read<FoyerProvider>(),
        stockProvider: context.read<StockProvider>());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // On attend que l'auth soit prête
      while (!authProvider.isInitialized) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!mounted) return;

      if (authProvider.isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        final foyerId = prefs.getInt('foyerId');

        if (foyerId != null) {
          // Charger le foyer dans le provider si tu veux préremplir
          _foyerController.setFoyerFromSharedPreferences();
          if (mounted) context.go('/home');
        } else {
          if (mounted) context.go('/choixInitial');
        }
      } else {
        context.go('/login');
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
