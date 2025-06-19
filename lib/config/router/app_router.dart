import 'package:co_habit_frontend/presentation/screens/screens.dart';
import 'package:co_habit_frontend/data/services/datasources/local/onboarding_service.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isOnboardingComplete =
          await OnboardingService.isOnboardingComplete();

      if (state.fullPath == '/' && !isOnboardingComplete) {
        return '/onboarding';
      }

      if (state.fullPath?.startsWith('/onboarding') == true &&
          isOnboardingComplete) {
        return '/maColoc';
      }

      if (state.fullPath == '/' && isOnboardingComplete) {
        return '/maColoc';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
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
        path: '/maColoc',
        builder: (context, state) => const MaColocScreen(),
      )
    ]);
