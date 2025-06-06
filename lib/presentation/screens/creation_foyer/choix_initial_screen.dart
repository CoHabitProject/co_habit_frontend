import 'package:co_habit_frontend/config/theme/buttons/app_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChoixInitialScreen extends StatelessWidget {
  const ChoixInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Je souhaite : ',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 60,
            ),
            _BuildChoixButton(
              onTap: () => context.push('/creerFoyer'),
              title: 'Créer une nouvelle colocation',
              icon: Icons.people_alt_outlined,
            ),
            const SizedBox(
              height: 50,
            ),
            _BuildChoixButton(
              onTap: () => context.push('/rejoindreColoc'),
              title: 'Rejoindre une colocation',
              icon: Icons.login_outlined,
            ),
          ],
        ),
      )),
    );
  }
}

class _BuildChoixButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;

  const _BuildChoixButton(
      {required this.onTap, required this.icon, required this.title});
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
