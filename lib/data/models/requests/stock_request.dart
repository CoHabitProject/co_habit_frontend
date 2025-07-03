class StockRequest {
  final String title;
  final String imageAsset;
  final String color;
  final int maxCapacity;

  StockRequest(
      {required this.title,
      required this.imageAsset,
      required this.color,
      required this.maxCapacity});

  Map<String, dynamic> toJson() => {
        'title': title,
        'imageAsset': imageAsset,
        'color': color,
        'maxCapacity': maxCapacity
      };
}
