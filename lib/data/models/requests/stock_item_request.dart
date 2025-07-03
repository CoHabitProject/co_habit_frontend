class StockItemRequest {
  final String name;
  final int quantity;

  StockItemRequest({required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};
}
