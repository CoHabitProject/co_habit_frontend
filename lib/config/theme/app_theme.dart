import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs de l'application
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color darkPrimaryColor = Color(0xFF0056C9);
  static const Color backgroundColor = Color(0xFFF6F9FC);
  static const Color navBarUnselected = Color(0x993F8EFC);
  // Fontes de l'application
  static const String primaryFont = 'Manrope';

  // Gradient du onboarding
  static const LinearGradient onboardingGradient = LinearGradient(
    colors: [Color(0xFF2E64F5), Color(0xFF5A8BFF)],
    begin: Alignment(0.50, -0.00),
    end: Alignment(0.50, 1.00),
  );

  static const onboardingTitle = TextStyle(
    color: Colors.white,
    fontSize: 42,
    fontFamily: AppTheme.primaryFont,
    fontWeight: FontWeight.w800,
    height: 1.5,
  );

  static const onboardingSubtitle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: AppTheme.primaryFont,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );
}
