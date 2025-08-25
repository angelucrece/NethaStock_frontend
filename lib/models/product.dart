class Product {
  final int id;
  final String name;
  final String code;
  final String description;
  final int quantity;
  final int threshold;
  final double price;
  final String? imageUrl;
  final int categoryId;
  final String? qrCode;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.quantity,
    required this.threshold,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    this.qrCode,
    required this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      quantity: json['quantity'],
      threshold: json['threshold'],
      price: json['price']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
      qrCode: json['qrCode'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'quantity': quantity,
      'threshold': threshold,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'qrCode': qrCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
    // ajoutez d'autres propriétés
  }) {
    return Product(
       id:  this.id,
      name: name ?? this.name,
      description: description ?? this.description,
     quantity: quantity?? this.quantity,
      // id: null, ctity '',
      threshold: threshold,
      price: price,
      categoryId: categoryId,
      createdAt: createdAt,
      code: code,
      // copiez les autres propriétés
    );
  }

  bool get isLowStock => quantity < threshold;
}