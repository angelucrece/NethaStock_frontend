// class StockReport {
//   final String name;
//   final String barcode;
//   final String category;
//   final int quantity;
//   final int threshold;
//   final double price;
//   final double stockValue;
//   final String alertLevel;
//
//   StockReport({
//     required this.name,
//     required this.barcode,
//     required this.category,
//     required this.quantity,
//     required this.threshold,
//     required this.price,
//     required this.stockValue,
//     required this.alertLevel,
//   });
//
//   factory StockReport.fromJson(Map<String, dynamic> json) {
//     return StockReport(
//       name: json['name'],
//       barcode: json['barcode'],
//       category: json['category_name'] ?? "",
//       quantity: json['quantity'],
//       threshold: json['threshold'],
//       price: (json['price'] as num).toDouble(),
//       stockValue: (json['stock_value'] as num).toDouble(),
//       alertLevel: json['alert_level'],
//     );
//   }
// }
