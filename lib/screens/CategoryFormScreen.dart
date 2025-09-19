import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
class CategoryFormScreen extends StatefulWidget {
  final Category? category; // null si ajout

  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    final productProvider = context.read<ProductProvider>();
    // if (productProvider.categories.isEmpty) {
    //   productProvider.loadCategories(); // Charger les catégories
    // }
    _nameController = TextEditingController(text: widget.category?.name ?? "");
    _descController =
        TextEditingController(text: widget.category?.description ?? "");
    _colorController =
        TextEditingController(text: widget.category?.color ?? "#2196F3");

  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? "Nouvelle catégorie" : "Modifier catégorie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (val) =>
                val == null || val.isEmpty ? "Nom requis" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: "Couleur (#RRGGBB)"),
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final regex = RegExp(r'^#([A-Fa-f0-9]{6})$');
                  if (!regex.hasMatch(val)) return "Format couleur invalide";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Créer ou mettre à jour l'objet Category
                    final category = Category(
                      id: widget.category?.id ?? 0,
                      name: _nameController.text.trim(),
                      description: _descController.text.trim().isNotEmpty
                          ? _descController.text.trim()
                          : null,
                      color: _colorController.text.trim().isNotEmpty
                          ? _colorController.text.trim()
                          : "#2196F3",
                      createdAt: widget.category?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                      productCount: widget.category?.productCount,
                      products: widget.category?.products,
                    );

                    final success = widget.category == null
                        ? await provider.addCategory(category, category.name)
                        : await provider.updateCategory(category);

                    if (success && mounted) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error ?? "Erreur")),
                      );
                    }
                  }
                },
                child: const Text("Enregistrer"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
