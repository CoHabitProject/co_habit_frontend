import 'dart:ui';

abstract class StockEntity {
  final int id;
  final String title;
  final int itemCount;
  final int totalItems;
  final Color color;
  final String imageAsset;

  StockEntity(
      {required this.id,
      required this.title,
      required this.itemCount,
      required this.totalItems,
      required this.color,
      required this.imageAsset});
}
