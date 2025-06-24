import 'dart:ui';

import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';

abstract class StockEntity {
  final int id;
  final String title;
  final Color color;
  final String imageAsset;
  final List<StockItemEntity> items;
  final int maxCapacity;

  StockEntity(
      {required this.id,
      required this.title,
      required this.color,
      required this.imageAsset,
      required this.items,
      required this.maxCapacity});

  int get totalItems => items.length;
  int get itemCount => items.fold(0, (sum, e) => sum + e.quantity);
  double get itemCountPercentage {
    if (maxCapacity == 0) return 0.0;
    return (itemCount / maxCapacity).clamp(0.0, 1.0);
  }
}
