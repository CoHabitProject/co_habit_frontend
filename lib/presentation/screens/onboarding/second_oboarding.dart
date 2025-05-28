import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/components/buttons/cohabit_button.dart';
import 'package:flutter/material.dart';

class SecondOboarding extends StatelessWidget {
  final VoidCallback onNext;
  const SecondOboarding({super.key, required this.onNext});

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
                padding: EdgeInsets.only(top: 60),
                child: Text("Organizes la vie à plusieurs",
                    textAlign: TextAlign.center,
                    style: AppTheme.onboardingTitle),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    "Créez, assignez et suivez les tâches du quotidien.",
                    textAlign: TextAlign.center,
                    style: AppTheme.onboardingSubtitle)),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    "Chacun sait quoi faire et quand, grâce aux rappels aux statuts en temps réel.",
                    textAlign: TextAlign.center,
                    style: AppTheme.onboardingSubtitle)),
            Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Image.asset("assets/onboarding/images/tasks.png")),
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
