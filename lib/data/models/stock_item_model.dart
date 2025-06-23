import 'package:co_habit_frontend/domain/entities/stock_item_entity.dart';

class StockItemModel extends StockItemEntity {
  StockItemModel(
      {required super.id, required super.name, required super.quantity});

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
        id: json['id'], name: json['name'], quantity: json['quantity']);
  }

  factory StockItemModel.fromEntity(StockItemEntity entity) {
    return StockItemModel(
        id: entity.id, name: entity.name, quantity: entity.quantity);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'quantity': quantity};
  }

  StockItemModel copyWith({int? id, String? name, int? quantity}) {
    return StockItemModel(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity);
  }
}
