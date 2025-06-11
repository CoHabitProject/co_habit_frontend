import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEMP LOGIN SCREEN'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            context.go('/choixInitial');
          },
          child: const Text('Suivant'),
        ),
      ),
    );
  }
}
