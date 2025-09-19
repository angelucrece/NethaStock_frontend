// import 'package:flutter/cupertino.dart';
//
// class Product {
//   final int id;
//   final String name;
//   final String barcode;
//   final Text? description;
//   final int quantity;
//   final int threshold;
//   final double price;
//   //final String? imageUrl;
//   final int categoryId;
//   //final String? qrCode;
//   final DateTime createdAt;
//   final DateTime? updatedAt;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.barcode,
//     required this.description,
//     required this.quantity,
//     required this.threshold,
//     required this.price,
//     //this.imageUrl,
//     required this.categoryId,
//     //this.qrCode,
//     required this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       barcode: json['code'],
//       description: json['description'],
//       quantity: json['quantity'],
//       threshold: json['threshold'],
//       price: json['price']?.toDouble() ?? 0.0,
//       //imageUrl: json['imageUrl'],
//       categoryId: json['categoryId'],
//       //qrCode: json['qrCode'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'code': barcode,
//       'description': description,
//       'quantity': quantity,
//       'threshold': threshold,
//       'price': price,
//       //'imageUrl': imageUrl,
//       'categoryId': categoryId,
//       //'qrCode': qrCode,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
//
//   Product copyWith({
//     String? id,
//     String? name,
//     Text? description,
//     int? quantity,
//     // ajoutez d'autres propriétés
//   }) {
//     return Product(
//        id:  this.id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//      quantity: quantity?? this.quantity,
//       // id: null, ctity '',
//       threshold: threshold,
//       price: price,
//       categoryId: categoryId,
//       createdAt: createdAt,
//       barcode: barcode,
//       // copiez les autres propriétés
//     );
//   }
//
//   bool get isLowStock => quantity < threshold;
// }
class Product {
  final int id;
  final String name;
  final String barcode;
  final String description;
  final int? categoryId;
  final double purchasePrice;
  final double price;
  final int quantity;
  final String? imageUrl;
  final int threshold;
  final String categoryName;
  final bool lowStock;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.description,
    this.categoryId,
    required this.purchasePrice,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.threshold,
    required this.categoryName,
    required this.lowStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    barcode: json['barcode'],
    description: json['description'] ?? '',
    categoryId: json['category_id'],
    purchasePrice: double.tryParse(json['purchase_price'].toString()) ?? 0.0,
    price: double.tryParse(json['price'].toString()) ?? 0.0,
    quantity: json['quantity'],
    imageUrl: json['image_url'],
    threshold: json['threshold'],
    categoryName: json['category_name'] ?? '',
    lowStock: json['low_stock'] ?? false,
  );

  String get fullImageUrl {
    if (imageUrl == null) return '';
    return imageUrl!.startsWith('http') ? imageUrl! : 'http://127.0.0.1:3000/api$imageUrl';
  }

  Product copyWith({
    int? id,
    String? name,
    String? barcode,
    String? description,
    int? categoryId,
    double? purchasePrice,
    double? price,
    int? quantity,
    String? imageUrl,
    int? threshold,
    String? categoryName,
    bool? lowStock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      threshold: threshold ?? this.threshold,
      categoryName: categoryName ?? this.categoryName,
      lowStock: lowStock ?? this.lowStock,
    );
  }
}
