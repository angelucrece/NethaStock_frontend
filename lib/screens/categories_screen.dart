import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import 'categoryFormScreen.dart';
import 'categoryDetailScreen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les catégories dès l'ouverture de l'écran
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catégories"),
      ),
      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryProvider.error != null
          ? Center(child: Text(categoryProvider.error!))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (ctx, i) {
          final category = categoryProvider.categories[i];
          return Card(
            child: ListTile(
              title: Text(category.name),
              subtitle:
              Text(category.description ?? "Pas de description"),
              leading: CircleAvatar(
                backgroundColor: category.color != null
                    ? Color(int.parse(
                    category.color!.replaceFirst('#', '0xFF')))
                    : Colors.grey,
              ),
              onTap: () {
                // On passe uniquement l'ID au lieu de l'objet complet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoriesScreen()// ID en int
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
