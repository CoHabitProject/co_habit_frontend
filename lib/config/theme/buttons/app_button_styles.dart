import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static final onboarding = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.onboardingGradient.colors.last,
    shadowColor: const Color(0x3F000000),
    elevation: 4,
    shape: RoundedRectangleBorder(
      side: const BorderSide(width: 3, color: Colors.white),
      borderRadius: BorderRadius.circular(20),
    ),
    minimumSize: const Size(331, 55),
    padding: const EdgeInsets.all(10),
  );

  static final gradient = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor:
        Colors.transparent, // Remove default shadow if you want clean gradient
    elevation: 0, // Remove elevation to avoid conflicting shadows
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(10),
  ).copyWith(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
  );
}
