class CreerStockItemRequest {
  final String name;
  final int quantity;

  CreerStockItemRequest({required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};
}
