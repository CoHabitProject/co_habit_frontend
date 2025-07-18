import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingNavbarButton extends StatelessWidget {
  final String routePath;
  const FloatingNavbarButton({super.key, required this.routePath});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FloatingNavbarController>(context);

    return Visibility(
      visible: controller.visible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: FloatingActionButton(
        onPressed: () {
          context.read<FloatingNavbarController>().triggerForRoute(routePath);
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}
