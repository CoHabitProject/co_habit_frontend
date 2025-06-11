import 'package:co_habit_frontend/config/theme/buttons/app_button_styles.dart';
import 'package:flutter/material.dart';

class ChoixInitialCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;

  const ChoixInitialCard(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 230,
        decoration: AppButtonStyles.gradientDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
