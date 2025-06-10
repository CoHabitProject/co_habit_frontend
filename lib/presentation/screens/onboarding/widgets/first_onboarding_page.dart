import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FirstOnboardingPage extends StatelessWidget {
  final VoidCallback onNext;
  const FirstOnboardingPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const _BuildGradientBackground(),
      const _BuildLogoSection(),
      const _BuildContentSection(),
      _BuildBottomButton(onNext: onNext)
    ]);
  }
}

class _BuildBottomButton extends StatelessWidget {
  const _BuildBottomButton({
    required this.onNext,
  });

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 16.3,
        child: CohabitButton(
          text: 'Commencer !',
          buttonType: ButtonType.onboarding,
          onPressed: onNext,
        ));
  }
}

class _BuildContentSection extends StatelessWidget {
  const _BuildContentSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 220),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Organiez vite, facilement, sereinement.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontFamily: AppTheme.primaryFont,
              fontWeight: FontWeight.w800,
              height: 1.5,
            ),
            softWrap: true,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Gérez les tâches, le budget et l’organisation de votre colocation, en toute simplicité',
            softWrap: true,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: AppTheme.primaryFont,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Lottie.network(
                "https://lottie.host/bfa31e32-75b0-48c7-a55f-5cdf9ff965e9/r30aopmIG5.json",
                height: 300)),
      ],
    );
  }
}

class _BuildLogoSection extends StatelessWidget {
  const _BuildLogoSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/onboarding/logo_white.png',
        width: 270,
        height: 300,
      ),
    );
  }
}

class _BuildGradientBackground extends StatelessWidget {
  const _BuildGradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: AppTheme.onboardingGradient,
      ),
    );
  }
}
