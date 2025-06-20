import 'package:flutter/material.dart';

Future<void> showCustomActionSheet(
    {required BuildContext context,
    required String title,
    required String subTitle,
    required List<Widget> actions}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CustomActionSheet(
      title: title,
      subTitle: subTitle,
      actions: actions,
    ),
  );
}

class CustomActionSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final List<Widget> actions;
  const CustomActionSheet(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(),
                  ...actions,
                ],
              ),
            ),
            CustomPaint(
              painter: _ArrowPainter(),
              child: const SizedBox(height: 10, width: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0) // en haut à gauche
      ..lineTo(size.width / 2, size.height) // pointe vers le bas
      ..lineTo(size.width, 0) // en haut à droite
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
