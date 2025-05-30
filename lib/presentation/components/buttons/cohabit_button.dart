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
        child: buttonType == ButtonType.onboarding
            ? _OnboardingButton(onPressed: onPressed, text: text)
            : _GradientButton(onPressed: onPressed, text: text));
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppButtonStyles.gradientDecoration,
      child: FilledButton(
          onPressed: onPressed,
          style: AppButtonStyles.primary,
          child: Text(text)),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const _OnboardingButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: AppButtonStyles.onboarding,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
