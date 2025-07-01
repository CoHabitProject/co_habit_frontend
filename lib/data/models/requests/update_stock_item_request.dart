class UpdateStockItemRequest {
  final String name;
  final int quantity;

  UpdateStockItemRequest({required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};
}
