import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/custom_app_bar.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/home_screen_navbar.dart';
import 'package:co_habit_frontend/presentation/widgets/common/flexible_card.dart';
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BuildHeaderCards(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Tâches récentes',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar:
          HomeScreenNavbar(currentIndex: _selectedIndex, onTap: (int index) {}),
      backgroundColor: AppTheme.backgroundColor,
    );
  }
}

class _BuildHeaderCards extends StatelessWidget {
  const _BuildHeaderCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        FlexibleCard(
          title: 'Dépenses',
          width: 200,
          height: 125,
          text: '725.46',
          icon: Icons.euro,
          borderRadius: 10,
          iconPosition: IconPosition.left,
          titleColor: Colors.black,
          titleSize: 17,
          titleWeight: FontWeight.normal,
          cardColor: AppTheme.homeCardBackroundColor,
          iconColor: Colors.black,
          textSize: 30,
          textWeight: FontWeight.bold,
        ),
        SizedBox(
          width: 10,
        ),
        FlexibleCard(
          title: 'Mes tâches',
          width: 170,
          height: 125,
          text: '03',
          icon: null,
          borderRadius: 10,
          textSize: 40,
          padding: EdgeInsets.all(15),
          textWeight: FontWeight.bold,
          titleSize: 17,
          cardColor: AppTheme.homeCardBackroundColor,
          textColor: AppTheme.darkPrimaryColor,
        )
      ],
    );
  }
}
