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

  const StockCard({
    super.key,
    required this.title,
    required this.itemCount,
    required this.totalItems,
    required this.color,
    required this.imageAsset,
    required this.itemCountPercentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 140,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$itemCount items',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 28.0,
                  lineWidth: 6.0,
                  percent: itemCountPercentage.clamp(0.0, 1.0),
                  center: Text(
                    '${(itemCountPercentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  progressColor: Colors.white,
                  backgroundColor: Colors.white24,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      imageAsset,
                      width: 60,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
