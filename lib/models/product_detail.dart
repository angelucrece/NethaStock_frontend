//ProductDetail pour les détails d’un produit (avec mouvements)

// import 'product.dart';
//
// class ProductMovement {
//   final int id;
//   final String type; // entry ou exit
//   final int quantity;
//   final String reason;
//   final String status;
//   final DateTime date;
//   final String userFirstName;
//   final String userLastName;
//
//   ProductMovement({
//     required this.id,
//     required this.type,
//     required this.quantity,
//     required this.reason,
//     required this.status,
//     required this.date,
//     required this.userFirstName,
//     required this.userLastName,
//   });
//
//   factory ProductMovement.fromJson(Map<String, dynamic> json) {
//     return ProductMovement(
//       id: json['id'],
//       type: json['type'],
//       quantity: json['quantity'],
//       reason: json['reason'],
//       status: json['status'],
//       date: DateTime.parse(json['date']),
//       userFirstName: json['first_name'],
//       userLastName: json['last_name'],
//     );
//   }
// }
//
// class ProductDetail extends Product {
//   final List<ProductMovement>? recentMovements;
//
//   ProductDetail({
//     required super.id,
//     required super.name,
//     super.barcode,
//     super.description,
//     super.categoryId,
//     super.categoryName,
//     required super.price,
//     required super.quantity,
//     required super.threshold,
//     super.purchasePrice,
//     super.imageUrl,
//     required super.lowStock,
//     super.createdAt,
//     super.updatedAt,
//     this.recentMovements,
//   });
//
//   factory ProductDetail.fromJson(Map<String, dynamic> json) {
//     return ProductDetail(
//       id: json['data']['id'],
//       name: json['data']['name'],
//       barcode: json['data']['barcode'],
//       description: json['data']['description'],
//       categoryId: json['data']['category_id'],
//       categoryName: json['data']['category_name'],
//       price: (json['data']['price'] as num).toDouble(),
//       quantity: json['data']['quantity'],
//       threshold: json['data']['threshold'],
//       purchasePrice: json['data']['purchase_price'] != null
//           ? (json['data']['purchase_price'] as num).toDouble()
//           : null,
//       imageUrl: json['data']['image_url'],
//       lowStock: json['data']['low_stock'] ?? false,
//       createdAt: json['data']['created_at'] != null
//           ? DateTime.parse(json['data']['created_at'])
//           : null,
//       updatedAt: json['data']['updated_at'] != null
//           ? DateTime.parse(json['data']['updated_at'])
//           : null,
//       recentMovements: json['data']['recentMovements'] != null
//           ? (json['data']['recentMovements'] as List)
//           .map((e) => ProductMovement.fromJson(e))
//           .toList()
//           : [],
//     );
//   }
// }
//
// class ImageUploadResponse {
//   final String imageUrl;
//
//   ImageUploadResponse({required this.imageUrl});
//
//   factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
//     return ImageUploadResponse(
//       imageUrl: json['data']['imageUrl'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'imageUrl': imageUrl,
//     };
//   }
// }
