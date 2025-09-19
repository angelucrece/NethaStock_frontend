//LowStockAlert pour les produits en stock faible

class LowStockAlert {
  final int id;
  final String name;
  final String? barcode;
  final int quantity;
  final int threshold;
  final String? categoryName;
  final int deficit;

  LowStockAlert({
    required this.id,
    required this.name,
    this.barcode,
    required this.quantity,
    required this.threshold,
    this.categoryName,
    required this.deficit,
  });

  factory LowStockAlert.fromJson(Map<String, dynamic> json) {
    return LowStockAlert(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      quantity: json['quantity'],
      threshold: json['threshold'],
      categoryName: json['category_name'],
      deficit: json['deficit'] ?? (json['threshold'] - json['quantity']),
    );
  }
}
