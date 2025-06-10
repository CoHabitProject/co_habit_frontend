import 'package:flutter/material.dart';

class CreerFoyerScreen extends StatelessWidget {
  const CreerFoyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création du foyer'),
      ),
      body: const SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      )),
    );
  }
}
