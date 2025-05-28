import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/config/theme/buttons/app_button_styles.dart';
import 'package:flutter/material.dart';

enum ButtonType { onboarding, gradient }

class CohabitButton extends StatelessWidget {
  final String text;
  final ButtonType buttonType;
  final VoidCallback? onPressed;

  const CohabitButton(
      {super.key,
      required this.text,
      required this.buttonType,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 331,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonType == ButtonType.onboarding
            ? AppButtonStyles.onboarding
            : AppButtonStyles.gradient,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: AppTheme.primaryFont,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
    // return Container(
    //   width: 331,
    //   height: 55,
    //   padding: const EdgeInsets.all(10),
    //   decoration: buttonType == ButtonType.onboarding
    //       ? onboardingShapeDecoration
    //       : gradientShapeDecoration,
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     spacing: 10,
    //     children: [
    //       Text(
    //         text,
    //         style: const TextStyle(
    //             color: Colors.white,
    //             fontSize: 20,
    //             fontFamily: AppTheme.primaryFont,
    //             fontWeight: FontWeight.w700),
    //       )
    //     ],
    //   ),
    // );
  }
}
