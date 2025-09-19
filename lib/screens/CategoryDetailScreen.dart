import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  final int categoryId; // ← type correct

  const CategoryDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.getProductsByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(title: const Text("Détails de la catégorie")),
      body: products.isEmpty
          ? const Center(child: Text("Aucun produit dans cette catégorie"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final product = products[i];
          return Card(
            child: ListTile(
              title: Text(product.name),
              subtitle: Text(
                  "Quantité : ${product.quantity} | Seuil : ${product.threshold}"),
            ),
          );
        },
      ),
    );
  }
}

extension on ProductProvider {
  getProductsByCategory(int categoryId) {}
}
