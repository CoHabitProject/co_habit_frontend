import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/custom_app_bar.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/home_screen_navbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  String firstName = 'Rocio';
  String lastName = 'Sierra';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        firstName: firstName,
        lastName: lastName,
        avatarColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text('Carlos'),
      ),
      bottomNavigationBar:
          HomeScreenNavbar(currentIndex: _selectedIndex, onTap: (int index) {}),
      backgroundColor: AppTheme.backgroundColor,
    );
  }
}
