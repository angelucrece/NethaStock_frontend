/// Modèle Category pour représenter une catégorie
/// adapté à ton backend Node/Express.
///
/// Champs pris en compte depuis l'API :
/// - id : identifiant unique de la catégorie
/// - name : nom de la catégorie
/// - description : description optionnelle
/// - createdAt : date de création (champ created_at en BDD)
/// - updatedAt : date de mise à jour (champ updated_at en BDD)
/// - productCount : nombre de produits actifs liés à cette catégorie
/// - products : liste optionnelle de produits (chargée dans GET /api/categories/:id)
///
import '../models/product.dart';
class Category {
  final int id;
  final String name;
  final String? description;
  final String? color;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? productCount;
  final List<Product>? products; // produits associés à cette catégorie

  Category({
    required this.id,
    required this.name,
    this.description,
    this.color,
    required this.createdAt,
    this.updatedAt,
    this.productCount,
    this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      description: json['description'] as String?,
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      productCount: json['product_count'] != null
          ? int.tryParse(json['product_count'].toString())
          : null,
      products: (json['products'] as List?)
          ?.map((p) => Product.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      // productCount et products ne sont pas envoyés au backend
    };
  }
}
