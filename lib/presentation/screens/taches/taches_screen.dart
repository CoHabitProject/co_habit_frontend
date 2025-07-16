import 'package:co_habit_frontend/presentation/widgets/common/screen_app_bar.dart';
import 'package:flutter/material.dart';

class TachesScreen extends StatefulWidget {
  const TachesScreen({super.key});

  @override
  State<TachesScreen> createState() => _TachesScreenState();
}

class _TachesScreenState extends State<TachesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(title: 'Tâches'),
      body: Center(
        child: Image.asset(
          'assets/images/onboarding/wip.png',
          height: 300,
        ),
      ),
    );
  }
}
