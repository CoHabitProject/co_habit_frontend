import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/components/buttons/cohabit_button.dart';
import 'package:flutter/material.dart';

class FourthOnboarding extends StatelessWidget {
  final VoidCallback onNext;
  const FourthOnboarding({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            gradient: AppTheme.onboardingGradient,
          ),
        ),
        Column(
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                child: Text("Ne tombez plus jamais à court !",
                    textAlign: TextAlign.center,
                    style: AppTheme.onboardingTitle),
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
                child: Image.asset("assets/onboarding/images/stock.png")),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 16.3,
            child: CohabitButton(
              text: 'Suivant',
              buttonType: ButtonType.onboarding,
              onPressed: onNext,
            ))
      ],
    );
  }
}
