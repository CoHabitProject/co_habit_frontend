abstract class StockItemEntity {
  final int id;
  final String name;
  final int quantity;

  StockItemEntity(
      {required this.id, required this.name, required this.quantity});
}
