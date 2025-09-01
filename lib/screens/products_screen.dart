import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  /// Écran de gestion des produits
  /// Affiche la liste des produits avec recherche, filtrage et actions

  final bool showLowStock; // Si true, affiche seulement les produits en stock bas

  ProductsScreen({this.showLowStock = false});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController(); // Controller pour la recherche
  String _searchQuery = ''; // Terme de recherche actuel
  ProductSort _sortOption = ProductSort.name; // Option de tri par défaut

  @override
  void initState() {
    super.initState();
    // Charge les produits au démarrage (après que le build soit complété)
    Future.delayed(Duration.zero, () {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // Utilise les produits en stock bas ou tous les produits selon le paramètre
    final products = widget.showLowStock
        ? productProvider.lowStockProducts
        : productProvider.products;

    // Applique les filtres et le tri
    final filteredProducts = _filterAndSortProducts(products);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showLowStock ? 'Produits en Alerte' : 'Gestion des Produits'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context),
            tooltip: 'Ajouter un produit',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Champ de recherche
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher un produit',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 12),

                // Options de tri
                Row(
                  children: [
                    const Text('Trier par:'),
                    const SizedBox(width: 12),
                    DropdownButton<ProductSort>(
                      value: _sortOption,
                      items: ProductSort.values.map((sort) {
                        return DropdownMenuItem<ProductSort>(
                          value: sort,
                          child: Text(
                            _getSortLabel(sort),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (ProductSort? newValue) {
                        if (newValue != null) {
                          setState(() => _sortOption = newValue);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Liste des produits
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState() // État vide si aucun produit
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () => _showProductDetails(context, product),
                  onEdit: () => _editProduct(context, product),
                  onDelete: () => _deleteProduct(context, product),
                );
              },
            ),
          ),
        ],
      ),

      // Bouton flottant pour ajouter un produit (seulement sur mobile)
      floatingActionButton: MediaQuery.of(context).size.width < 600
          ? FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      )
          : null,
    );
  }

  /// Construit l'état vide quand il n'y a pas de produits
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            widget.showLowStock
                ? 'Aucun produit en alerte de stock'
                : 'Aucun produit trouvé',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Essayez avec d\'autres termes de recherche',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }

  /// Filtre et trie les produits selon les critères actuels
  List<Product> _filterAndSortProducts(List<Product> products) {
    List<Product> result = products;

    // Filtrage par terme de recherche
    if (_searchQuery.isNotEmpty) {
      result = result.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.barcode.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Tri selon l'option sélectionnée
    switch (_sortOption) {
      case ProductSort.name:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSort.code:
        result.sort((a, b) => a.barcode.compareTo(b.barcode));
        break;
      case ProductSort.quantity:
        result.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case ProductSort.lowStock:
        result.sort((a, b) {
          final aRatio = a.quantity / a.threshold;
          final bRatio = b.quantity / b.threshold;
          return aRatio.compareTo(bRatio);
        });
        break;
    }

    return result;
  }

  /// Retourne le libellé lisible pour une option de tri
  String _getSortLabel(ProductSort sort) {
    switch (sort) {
      case ProductSort.name: return 'Nom';
      case ProductSort.code: return 'Code';
      case ProductSort.quantity: return 'Quantité';
      case ProductSort.lowStock: return 'Niveau de stock';
    }
  }

  /// Affiche le dialogue d'ajout de produit
  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Produit'),
        content: AddProductForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la sauvegarde du produit
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  /// Affiche les détails d'un produit dans une bottom sheet
  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProductDetailsSheet(product: product),
    );
  }

  /// Édite un produit existant
  void _editProduct(BuildContext context, Product product) {
    // TODO: Implémenter l'édition de produit
  }

  /// Supprime un produit après confirmation
  void _deleteProduct(BuildContext context, Product product) {
    // TODO: Implémenter la suppression avec confirmation
  }
}

// Enumération des options de tri disponibles
enum ProductSort { name, code, quantity, lowStock }

// Formulaire d'ajout de produit (à compléter)
// class AddProductForm extends StatefulWidget {
//   @override
//   _AddProductFormState createState() => _AddProductFormState();
// }
//
// class _AddProductFormState extends State<AddProductForm> {
//   // TODO: Implémenter le formulaire complet
//   @override
//   Widget build(BuildContext context) {
//     return const Text('Formulaire d\'ajout de produit');
//   }
// }




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Produits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: AddProductForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _thresholdController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSection;
  bool _isActive = true;
  bool _isLoading = false;

  // Listes déroulantes fictives
  final List<String> _categories = ['Électronique', 'Vêtements', 'Alimentation', 'Maison', 'Sport'];
  final List<String> _sections = ['Rayon A', 'Rayon B', 'Rayon C', 'Entrepôt', 'Vitrine'];

  // Gestion de la sélection d'image
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // Initialiser avec des valeurs par défaut valides
    _quantityController.text = '1';
    _thresholdController.text = '1';
  }

  Future<void> _pickImage() async {
    // Simulation de sélection d'image
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _imagePath = 'assets/sample_product_image.jpg';
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image sélectionnée avec succès')),
    );
  }

  // Validation des nombres positifs
  String? _validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (number <= 0) {
      return '$fieldName doit être supérieur à 0';
    }

    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulation de traitement
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      // Réinitialisation du formulaire
      _formKey.currentState!.reset();
      setState(() {
        _selectedCategory = null;
        _selectedSection = null;
        _imagePath = null;
        _isActive = true;
        _quantityController.text = '1';
        _thresholdController.text = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section d'import d'image
              _buildImageSection(),
              SizedBox(height: 24),

              // Champ nom du produit
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom du produit',
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de produit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ seuil d'alerte avec input type="number"
              TextFormField(
                controller: _thresholdController,
                decoration: InputDecoration(
                  labelText: 'Seuil d\'alerte',
                  prefixIcon: Icon(Icons.warning),
                  suffixText: 'unités',
                ),
                keyboardType: TextInputType.number, // Équivalent à <input type="number">
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // N'autorise que les chiffres
                ],
                validator: (value) => _validatePositiveNumber(value, 'Le seuil'),
              ),
              SizedBox(height: 16),

              // Champ quantité avec input type="number"
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantité',
                  prefixIcon: Icon(Icons.inventory),
                  suffixText: 'unités',
                ),
                keyboardType: TextInputType.number, // Équivalent à <input type="number">
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // N'autorise que les chiffres
                ],
                validator: (value) => _validatePositiveNumber(value, 'La quantité'),
              ),
              SizedBox(height: 16),

              // Sélection de catégorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Sélection de section
              DropdownButtonFormField<String>(
                value: _selectedSection,
                decoration: InputDecoration(
                  labelText: 'Sectionner une catégorie',
                  prefixIcon: Icon(Icons.location_on),
                ),
                items: _sections.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSection = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une section';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Switch Actif
              Row(
                children: [
                  Icon(Icons.toggle_on, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Actif', style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Bouton d'ajout
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  'Ajouter',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image du produit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _imagePath == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8),
                Text(
                  'Cliquer pour importer une image',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _imagePath!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        if (_isLoading)
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }
}

// Bottom sheet de détails de produit (à compléter)
class ProductDetailsSheet extends StatelessWidget {
  final Product product;

  const ProductDetailsSheet({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Text('Détails de ${product.name}'),
    );
  }
}