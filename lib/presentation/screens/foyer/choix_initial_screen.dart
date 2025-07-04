import 'package:co_habit_frontend/presentation/screens/foyer/widgets/choix_initial_card.dart';
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
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Je souhaite : ',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 60),
            ChoixInitialCard(
              onTap: () => context.push('/creerFoyer'),
              title: 'Créer une nouvelle colocation',
              icon: Icons.people_alt_outlined,
            ),
            const SizedBox(height: 50),
            ChoixInitialCard(
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
