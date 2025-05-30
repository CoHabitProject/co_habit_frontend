import 'package:co_habit_frontend/presentation/screens/onboarding/first_onboarding.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/fourth_onboarding.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/second_oboarding.dart';
import 'package:co_habit_frontend/presentation/screens/onboarding/third_onboarding.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
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
          FirstOnboarding(onNext: _nextPage),
          SecondOboarding(onNext: _nextPage),
          ThirdOnboarding(onNext: _nextPage),
          FourthOnboarding(onNext: _nextPage)
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
