// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom : ${product.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Prix : ${product.price} FCFA", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Code-barres :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            BarcodeWidget(
              barcode: Barcode.code128(),
              data: product.barcode, // valeur renvoyée par ton backend
              width: 200,
              height: 80,
              drawText: true,
            ),
          ],
        ),
      ),
    );
  }
}
