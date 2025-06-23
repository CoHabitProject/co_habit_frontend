import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StockCard extends StatelessWidget {
  final String title;
  final int itemCount;
  final int totalItems;
  final Color color;
  final String imageAsset;
  final double itemCountPercentage;
  final VoidCallback? onTap;

  const StockCard(
      {super.key,
      required this.title,
      required this.itemCount,
      required this.totalItems,
      required this.color,
      required this.imageAsset,
      required this.itemCountPercentage,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        height: 140,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const Spacer(),
                Text(
                  '$itemCount items',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularPercentIndicator(
                  radius: 28.0,
                  lineWidth: 6.0,
                  percent: itemCountPercentage,
                  center: Text(
                    '${(itemCountPercentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  progressColor: Colors.white,
                  backgroundColor: Colors.white24,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset(
                    imageAsset,
                    width: 70,
                    height: 57,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
