import 'package:co_habit_frontend/presentation/screens/auth/login_screen.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/onboarding_view.dart';
import 'package:co_habit_frontend/presentation/screens/temp_home.dart';
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
        return '/login';
      }

      if (state.fullPath == '/' && isOnboardingComplete) {
        return '/login';
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
    ]);
