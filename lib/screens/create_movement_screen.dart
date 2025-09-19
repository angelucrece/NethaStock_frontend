

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movement.dart';
import '../providers/movement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movement.dart';
import '../models/product.dart';
import '../providers/movement_provider.dart';
import '../providers/product_provider.dart';
class AddMovementScreen extends StatefulWidget {
  const AddMovementScreen({super.key});

  @override
  State<AddMovementScreen> createState() => _AddMovementScreenState();
}

class _AddMovementScreenState extends State<AddMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  Product? _selectedProduct;
  String _selectedType = 'entry'; // 'entry' ou 'exit'
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _motifController = TextEditingController();
  bool _isLoading = false;
  bool _isProductsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.loadProducts();
    setState(() {
      _isProductsLoading = false;
      // Si la liste contient au moins un produit, le sélectionner par défaut
      if (productProvider.products.isNotEmpty) {
        _selectedProduct = productProvider.products.first;
      }
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _motifController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true || _selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs correctement')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final movement = Movement(
      productId: _selectedProduct!.id,
      productName: _selectedProduct!.name,
      type: _selectedType,
      quantity: int.parse(_quantityController.text),
      motif: _motifController.text,
      date: DateTime.now(),
      status: '',
      createdAt: DateTime.now(),
    );

    final success = await Provider.of<MovementProvider>(context, listen: false)
        .addMovement(movement);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mouvement créé avec succès')),
      );
      Navigator.pop(context, true); // Retour à l’écran précédent
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création du mouvement')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un mouvement')),
      body: _isProductsLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Sélection produit
              DropdownButtonFormField<Product>(
                value: _selectedProduct,
                decoration: const InputDecoration(labelText: 'Produit'),
                items: products.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.name),
                )).toList(),
                onChanged: (p) => setState(() => _selectedProduct = p),
                validator: (p) => p == null ? 'Veuillez sélectionner un produit' : null,
              ),

              const SizedBox(height: 16),

              // Type de mouvement
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'entry', child: Text('Entrée')),
                  DropdownMenuItem(value: 'exit', child: Text('Sortie')),
                ],
                onChanged: (t) => setState(() => _selectedType = t ?? 'entry'),
              ),
              const SizedBox(height: 16),

              // Quantité
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantité'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Veuillez entrer une quantité';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Quantité invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Motif
              TextFormField(
                controller: _motifController,
                decoration: const InputDecoration(labelText: 'Motif'),
              ),
              const SizedBox(height: 32),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text('Créer le mouvement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
