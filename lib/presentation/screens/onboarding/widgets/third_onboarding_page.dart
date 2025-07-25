import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:flutter/material.dart';

class ThirdOnboardingPage extends StatelessWidget {
  final VoidCallback onNext;
  const ThirdOnboardingPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _BuildGradientBackground(),
        const _BuildContentSection(),
        _BuildBottomButton(onNext: onNext)
      ],
    );
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
        heightFactor: 15,
        child: CohabitButton(
          text: 'Suivant',
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
      children: [
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 60, left: 10, right: 10),
            child: Text("Un budget clair pour éviter les embrouilles",
                textAlign: TextAlign.center, style: AppTheme.onboardingTitle),
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Suivez les dépenses communes,",
                textAlign: TextAlign.center,
                style: AppTheme.onboardingSubtitle)),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("remboursez en un clein d’œil,",
                textAlign: TextAlign.center,
                style: AppTheme.onboardingSubtitle)),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("et répartissez les frais entre colocataaires.",
                textAlign: TextAlign.center,
                style: AppTheme.onboardingSubtitle)),
        Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Image.asset("assets/images/onboarding/budget.png")),
      ],
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
