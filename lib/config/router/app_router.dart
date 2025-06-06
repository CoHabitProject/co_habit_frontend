import 'package:co_habit_frontend/presentation/screens/screens.dart';
import 'package:co_habit_frontend/services/onboarding_service.dart';
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
        return '/choixInitial';
      }

      if (state.fullPath == '/' && isOnboardingComplete) {
        return '/choixInitial';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TempHome(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
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
    ]);
