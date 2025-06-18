import 'package:co_habit_frontend/domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  StockModel(
      {required super.id,
      required super.title,
      required super.itemCount,
      required super.totalItems,
      required super.color,
      required super.imageAsset});

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
        id: json['id'],
        title: json['title'],
        itemCount: json['itemCount'],
        totalItems: json['totalItems'],
        color: json['color'],
        imageAsset: json['imageAsset']);
  }

  factory StockModel.fromEntity(StockEntity entity) {
    return StockModel(
        id: entity.id,
        title: entity.title,
        itemCount: entity.itemCount,
        totalItems: entity.totalItems,
        color: entity.color,
        imageAsset: entity.imageAsset);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'itemCount': itemCount,
      'totalItems': totalItems,
      'color': color,
      'imageAsset': imageAsset
    };
  }
}
