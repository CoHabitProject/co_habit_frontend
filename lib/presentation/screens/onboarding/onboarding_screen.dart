import 'package:co_habit_frontend/presentation/screens/onboarding/widgets/first_onboarding_page.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/widgets/fourth_onboarding_page.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/widgets/second_oboarding_page.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/widgets/third_onboarding_page.dart';
import 'package:co_habit_frontend/data/services/datasources/local/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Si on est à la dernière page, on peut naviguer vers une autre vue
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
    }
  }

  Future<void> _completeOnboarding() async {
    await OnboardingService.setOnboardingComplete();

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (page) => setState(() {
          _currentPage = page;
        }),
        children: [
          FirstOnboardingPage(onNext: _nextPage),
          SecondOboardingPage(onNext: _nextPage),
          ThirdOnboardingPage(onNext: _nextPage),
          FourthOnboardingPage(onNext: _completeOnboarding)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
