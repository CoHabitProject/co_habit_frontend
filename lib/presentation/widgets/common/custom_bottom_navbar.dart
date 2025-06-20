import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavbar extends StatelessWidget {
  final bool showCenterButton;

  const CustomBottomNavbar({super.key, required this.showCenterButton});

  static const _navItems = [
    {'icon': Icons.home, 'label': 'Home', 'route': '/home'},
    {'icon': Icons.attach_money, 'label': 'Dépenses', 'route': '/depenses'},
    {'icon': Icons.check_box, 'label': 'Tâches', 'route': '/taches'},
    {'icon': Icons.group, 'label': 'Coloc', 'route': '/maColoc'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    return BottomAppBar(
      shape: showCenterButton ? const CircularNotchedRectangle() : null,
      notchMargin: showCenterButton ? 8.0 : 0.0,
      elevation: 8,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, _navItems[0], currentPath),
            _buildNavItem(context, _navItems[1], currentPath),
            if (showCenterButton) const SizedBox(width: 40) else Container(),
            _buildNavItem(context, _navItems[2], currentPath),
            _buildNavItem(context, _navItems[3], currentPath),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, Map<String, dynamic> item, String currentPath) {
    final String route = item['route'];
    final bool isSelected = currentPath == route;

    return GestureDetector(
      onTap: () {
        if (!isSelected) context.go(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item['icon'],
            color: isSelected
                ? AppTheme.darkPrimaryColor
                : AppTheme.navBarUnselected,
          ),
          const SizedBox(height: 4),
          Text(
            item['label'],
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? AppTheme.darkPrimaryColor
                  : AppTheme.navBarUnselected,
            ),
          )
        ],
      ),
    );
  }
}
