import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HomeScreenNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeScreenNavbar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.darkPrimaryColor,
      unselectedItemColor: AppTheme.navBarUnselected,
      showUnselectedLabels: true,
      elevation: 3,
      items: const [
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Icons.home),
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Icons.attach_money),
            ),
            label: 'Dépenses'),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Icons.check_box),
            ),
            label: 'Tâches'),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Icons.group),
            ),
            label: 'Coloc'),
      ],
    );
  }
}
