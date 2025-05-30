import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static final onboarding = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white, width: 3),
      backgroundColor: Colors.transparent);

  static final primary = FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(10),
  );

  static const gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [AppTheme.darkPrimaryColor, AppTheme.primaryColor]),
      borderRadius: BorderRadius.all(Radius.circular(20)));
}
