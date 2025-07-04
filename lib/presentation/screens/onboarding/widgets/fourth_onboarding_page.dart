import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:flutter/material.dart';

class FourthOnboardingPage extends StatelessWidget {
  final VoidCallback onNext;
  const FourthOnboardingPage({super.key, required this.onNext});

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
            child: Text("Ne tombez plus jamais à court !",
                textAlign: TextAlign.center, style: AppTheme.onboardingTitle),
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Gardez un œil sur les produits de la maison.",
                textAlign: TextAlign.center,
                style: AppTheme.onboardingSubtitle)),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Recevez des alertes sur les produits manquants,",
                textAlign: TextAlign.center,
                style: AppTheme.onboardingSubtitle)),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("et organisez les achats collectifs facilement.",
                textAlign: TextAlign.center,
                style: AppTheme.onboardingSubtitle)),
        Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Image.asset("assets/images/onboarding/stock.png")),
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
