import 'package:co_habit_frontend/presentation/screens/depenses/widgets/categorie_depenses_screen.dart';
import 'package:co_habit_frontend/presentation/screens/screens.dart';
import 'package:co_habit_frontend/data/services/datasources/local/onboarding_service.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_bottom_navbar.dart';
import 'package:co_habit_frontend/presentation/widgets/common/floating_navbar_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isOnboardingComplete =
          await OnboardingService.isOnboardingComplete();

      final path = state.fullPath ?? '';

      if (!path.startsWith('/onboarding') && !isOnboardingComplete) {
        return '/onboarding';
      }

      if (isOnboardingComplete && path.startsWith('/oboarding')) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Routes sans navbar
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final message = state.extra as String?;
          return LoginScreen(initialMessage: message);
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/choixInitial',
        builder: (context, state) => const ChoixInitialScreen(),
      ),
      GoRoute(
        path: '/rejoindreColoc',
        builder: (context, state) => const RejoindreColocScreen(),
      ),
      GoRoute(
        path: '/creerFoyer',
        builder: (context, state) => const CreerFoyerScreen(),
      ),
      GoRoute(
        path: '/creerStock',
        builder: (context, state) => const AjoutStockScreen(),
      ),
      GoRoute(
        path: '/creerDepense',
        builder: (context, state) => const AjouterDepenseScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Routes avec navbar commune via ShellRoute
      ShellRoute(
        routes: [
          GoRoute(
            path: '/home',
            name: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/maColoc',
            name: '/maColoc',
            builder: (context, state) => const MaColocScreen(),
          ),
          GoRoute(
            path: '/maColoc/stock/:stockId',
            name: '/maColoc/stock/:stockId',
            builder: (context, state) {
              final stockId = int.parse(state.pathParameters['stockId']!);
              return StockDetailScreen(stockId: stockId);
            },
          ),
          GoRoute(
            path: '/taches',
            name: '/taches',
            builder: (context, state) => const TachesScreen(),
          ),
          GoRoute(
            path: '/depenses/:label',
            builder: (context, state) {
              final label = state.pathParameters['label']!;
              return CategorieDepensesScreen(categoryLabel: label);
            },
          ),
          GoRoute(
            path: '/depenses',
            name: '/depenses',
            builder: (context, state) => const DepensesScreen(),
          )
        ],
        builder: (context, state, child) {
          final stringPath = state.uri.toString();

          final showCenterButton = stringPath.contains('/maColoc') ||
              stringPath.contains('/taches') ||
              stringPath.contains('/depenses');

          final isHomeScreen = stringPath == '/home';

          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNavbar(
                showCenterButton: !isHomeScreen && showCenterButton),
            floatingActionButton: isHomeScreen
                ? null
                : FloatingNavbarButton(routePath: stringPath),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      )
    ]);
