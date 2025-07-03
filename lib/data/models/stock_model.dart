import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class StockModel extends StockEntity {
  StockModel(
      {required super.id,
      required super.title,
      required super.color,
      required super.imageAsset,
      required super.items,
      required super.maxCapacity});

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
        id: json['id'],
        title: json['title'],
        color: Color(int.parse(json['color'], radix: 16)),
        imageAsset: json['imageAsset'],
        items: json['items'] ?? List.empty(),
        maxCapacity: json['maxCapacity']);
  }

  factory StockModel.fromEntity(StockEntity entity) {
    return StockModel(
        id: entity.id,
        title: entity.title,
        color: entity.color,
        imageAsset: entity.imageAsset,
        items: entity.items,
        maxCapacity: entity.maxCapacity);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'color': color.toHexString(),
      'imageAsset': imageAsset,
      'items': items,
      'maxCapacity': maxCapacity
    };
  }

  StockModel copyWith(
      {int? id,
      String? title,
      Color? color,
      String? imageAsset,
      List<StockItemEntity>? items,
      int? maxCapacity}) {
    return StockModel(
        id: id ?? this.id,
        title: title ?? this.title,
        color: color ?? this.color,
        imageAsset: imageAsset ?? this.imageAsset,
        items: items ?? this.items,
        maxCapacity: maxCapacity ?? this.maxCapacity);
  }
}
