import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ScreenAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppTheme.backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
