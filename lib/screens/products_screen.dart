// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../providers/product_provider.dart';
// import '../models/product.dart';
// import '../widgets/product_card.dart';
//
// class ProductsScreen extends StatefulWidget {
//   /// Écran de gestion des produits
//   /// Affiche la liste des produits avec recherche, filtrage et actions
//
//   final bool showLowStock; // Si true, affiche seulement les produits en stock bas
//
//   ProductsScreen({this.showLowStock = false});
//
//   @override
//   _ProductsScreenState createState() => _ProductsScreenState();
// }
//
// class _ProductsScreenState extends State<ProductsScreen> {
//   final _searchController = TextEditingController(); // Controller pour la recherche
//   String _searchQuery = ''; // Terme de recherche actuel
//   ProductSort _sortOption = ProductSort.name; // Option de tri par défaut
//
//   @override
//   void initState() {
//     super.initState();
//     // Charge les produits au démarrage (après que le build soit complété)
//     Future.delayed(Duration.zero, () {
//       Provider.of<ProductProvider>(context, listen: false).fetchProducts();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     // Utilise les produits en stock bas ou tous les produits selon le paramètre
//     final products = widget.showLowStock
//         ? productProvider.lowStockProducts
//         : productProvider.products;
//
//     // Applique les filtres et le tri
//     final filteredProducts = _filterAndSortProducts(products);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.showLowStock ? 'Produits en Alerte' : 'Gestion des Produits'),
//         backgroundColor: Colors.blue.shade700,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddProductDialog(context),
//             tooltip: 'Ajouter un produit',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Barre de recherche et filtres
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Champ de recherche
//                 TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     labelText: 'Rechercher un produit',
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() => _searchQuery = '');
//                       },
//                     )
//                         : null,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     setState(() => _searchQuery = value);
//                   },
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Options de tri
//                 Row(
//                   children: [
//                     const Text('Trier par:'),
//                     const SizedBox(width: 12),
//                     DropdownButton<ProductSort>(
//                       value: _sortOption,
//                       items: ProductSort.values.map((sort) {
//                         return DropdownMenuItem<ProductSort>(
//                           value: sort,
//                           child: Text(
//                             _getSortLabel(sort),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (ProductSort? newValue) {
//                         if (newValue != null) {
//                           setState(() => _sortOption = newValue);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Liste des produits
//           Expanded(
//             child: filteredProducts.isEmpty
//                 ? _buildEmptyState() // État vide si aucun produit
//                 : ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: filteredProducts.length,
//               itemBuilder: (context, index) {
//                 final product = filteredProducts[index];
//                 return ProductCard(
//                   product: product,
//                   onTap: () => _showProductDetails(context, product),
//                   onEdit: () => _editProduct(context, product),
//                   onDelete: () => _deleteProduct(context, product),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//
//       // Bouton flottant pour ajouter un produit (seulement sur mobile)
//       floatingActionButton: MediaQuery.of(context).size.width < 600
//           ? FloatingActionButton(
//         onPressed: () => _showAddProductDialog(context),
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.orange,
//       )
//           : null,
//     );
//   }
//
//   /// Construit l'état vide quand il n'y a pas de produits
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inventory_2,
//             size: 64,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             widget.showLowStock
//                 ? 'Aucun produit en alerte de stock'
//                 : 'Aucun produit trouvé',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           if (_searchQuery.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             Text(
//               'Essayez avec d\'autres termes de recherche',
//               style: TextStyle(color: Colors.grey.shade500),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   /// Filtre et trie les produits selon les critères actuels
//   List<Product> _filterAndSortProducts(List<Product> products) {
//     List<Product> result = products;
//
//     // Filtrage par terme de recherche
//     if (_searchQuery.isNotEmpty) {
//       result = result.where((product) {
//         return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//             product.barcode.toLowerCase().contains(_searchQuery.toLowerCase());
//       }).toList();
//     }
//
//     // Tri selon l'option sélectionnée
//     switch (_sortOption) {
//       case ProductSort.name:
//         result.sort((a, b) => a.name.compareTo(b.name));
//         break;
//       case ProductSort.code:
//         result.sort((a, b) => a.barcode.compareTo(b.barcode));
//         break;
//       case ProductSort.quantity:
//         result.sort((a, b) => a.quantity.compareTo(b.quantity));
//         break;
//       case ProductSort.lowStock:
//         result.sort((a, b) {
//           final aRatio = a.quantity / a.threshold;
//           final bRatio = b.quantity / b.threshold;
//           return aRatio.compareTo(bRatio);
//         });
//         break;
//     }
//
//     return result;
//   }
//
//   /// Retourne le libellé lisible pour une option de tri
//   String _getSortLabel(ProductSort sort) {
//     switch (sort) {
//       case ProductSort.name: return 'Nom';
//       case ProductSort.code: return 'Code';
//       case ProductSort.quantity: return 'Quantité';
//       case ProductSort.lowStock: return 'Niveau de stock';
//     }
//   }
//
//   /// Affiche le dialogue d'ajout de produit
//   void _showAddProductDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Nouveau Produit'),
//         content: AddProductForm(),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Annuler'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // TODO: Implémenter la sauvegarde du produit
//               Navigator.pop(context);
//             },
//             child: const Text('Enregistrer'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Affiche les détails d'un produit dans une bottom sheet
//   void _showProductDetails(BuildContext context, Product product) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => ProductDetailsSheet(product: product),
//     );
//   }
//
//   /// Édite un produit existant
//   void _editProduct(BuildContext context, Product product) {
//     // TODO: Implémenter l'édition de produit
//   }
//
//   /// Supprime un produit après confirmation
//   void _deleteProduct(BuildContext context, Product product) {
//     // TODO: Implémenter la suppression avec confirmation
//   }
// }
//
// // Enumération des options de tri disponibles
// enum ProductSort { name, code, quantity, lowStock }
//
// // Formulaire d'ajout de produit (à compléter)
// // class AddProductForm extends StatefulWidget {
// //   @override
// //   _AddProductFormState createState() => _AddProductFormState();
// // }
// //
// // class _AddProductFormState extends State<AddProductForm> {
// //   // TODO: Implémenter le formulaire complet
// //   @override
// //   Widget build(BuildContext context) {
// //     return const Text('Formulaire d\'ajout de produit');
// //   }
// // }
//
//
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gestion de Produits',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//       ),
//       home: AddProductForm(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class AddProductForm extends StatefulWidget {
//   @override
//   _AddProductFormState createState() => _AddProductFormState();
// }
//
// class _AddProductFormState extends State<AddProductForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _thresholdController = TextEditingController();
//
//   String? _selectedCategory;
//   String? _selectedSection;
//   bool _isActive = true;
//   bool _isLoading = false;
//
//   // Listes déroulantes fictives
//   final List<String> _categories = ['Électronique', 'Vêtements', 'Alimentation', 'Maison', 'Sport'];
//   final List<String> _sections = ['Rayon A', 'Rayon B', 'Rayon C', 'Entrepôt', 'Vitrine'];
//
//   // Gestion de la sélection d'image
//   String? _imagePath;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialiser avec des valeurs par défaut valides
//     _quantityController.text = '1';
//     _thresholdController.text = '1';
//   }
//
//   Future<void> _pickImage() async {
//     // Simulation de sélection d'image
//     setState(() {
//       _isLoading = true;
//     });
//
//     await Future.delayed(Duration(seconds: 1));
//
//     setState(() {
//       _imagePath = 'assets/sample_product_image.jpg';
//       _isLoading = false;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Image sélectionnée avec succès')),
//     );
//   }
//
//   // Validation des nombres positifs
//   String? _validatePositiveNumber(String? value, String fieldName) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer $fieldName';
//     }
//
//     final number = int.tryParse(value);
//     if (number == null) {
//       return 'Veuillez entrer un nombre valide';
//     }
//
//     if (number <= 0) {
//       return '$fieldName doit être supérieur à 0';
//     }
//
//     return null;
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       // Simulation de traitement
//       await Future.delayed(Duration(seconds: 2));
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Produit ajouté avec succès!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       // Réinitialisation du formulaire
//       _formKey.currentState!.reset();
//       setState(() {
//         _selectedCategory = null;
//         _selectedSection = null;
//         _imagePath = null;
//         _isActive = true;
//         _quantityController.text = '1';
//         _thresholdController.text = '1';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ajouter un produit'),
//         elevation: 0,
//         backgroundColor: Colors.blue.shade700,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Section d'import d'image
//               _buildImageSection(),
//               SizedBox(height: 24),
//
//               // Champ nom du produit
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Nom du produit',
//                   prefixIcon: Icon(Icons.shopping_bag),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer un nom de produit';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//
//               // Champ seuil d'alerte avec input type="number"
//               TextFormField(
//                 controller: _thresholdController,
//                 decoration: InputDecoration(
//                   labelText: 'Seuil d\'alerte',
//                   prefixIcon: Icon(Icons.warning),
//                   suffixText: 'unités',
//                 ),
//                 keyboardType: TextInputType.number, // Équivalent à <input type="number">
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly, // N'autorise que les chiffres
//                 ],
//                 validator: (value) => _validatePositiveNumber(value, 'Le seuil'),
//               ),
//               SizedBox(height: 16),
//
//               // Champ quantité avec input type="number"
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: InputDecoration(
//                   labelText: 'Quantité',
//                   prefixIcon: Icon(Icons.inventory),
//                   suffixText: 'unités',
//                 ),
//                 keyboardType: TextInputType.number, // Équivalent à <input type="number">
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly, // N'autorise que les chiffres
//                 ],
//                 validator: (value) => _validatePositiveNumber(value, 'La quantité'),
//               ),
//               SizedBox(height: 16),
//
//               // Sélection de catégorie
//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 decoration: InputDecoration(
//                   labelText: 'Catégorie',
//                   prefixIcon: Icon(Icons.category),
//                 ),
//                 items: _categories.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedCategory = newValue;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez sélectionner une catégorie';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//
//               // Sélection de section
//               DropdownButtonFormField<String>(
//                 value: _selectedSection,
//                 decoration: InputDecoration(
//                   labelText: 'Sectionner une catégorie',
//                   prefixIcon: Icon(Icons.location_on),
//                 ),
//                 items: _sections.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedSection = newValue;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez sélectionner une section';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//
//               // Switch Actif
//               Row(
//                 children: [
//                   Icon(Icons.toggle_on, color: Colors.blue),
//                   SizedBox(width: 12),
//                   Text('Actif', style: TextStyle(fontSize: 16)),
//                   Spacer(),
//                   Switch(
//                     value: _isActive,
//                     onChanged: (value) {
//                       setState(() {
//                         _isActive = value;
//                       });
//                     },
//                     activeColor: Colors.blue,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 32),
//
//               // Bouton d'ajout
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _submitForm,
//                 child: _isLoading
//                     ? SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : Text(
//                   'Ajouter',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue.shade700,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Image du produit',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(height: 8),
//         GestureDetector(
//           onTap: _pickImage,
//           child: Container(
//             height: 150,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: _imagePath == null
//                 ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.cloud_upload,
//                   size: 40,
//                   color: Colors.grey.shade400,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Cliquer pour importer une image',
//                   style: TextStyle(color: Colors.grey.shade600),
//                 ),
//               ],
//             )
//                 : ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(
//                 _imagePath!,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),
//           ),
//         ),
//         if (_isLoading)
//           LinearProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _quantityController.dispose();
//     _thresholdController.dispose();
//     super.dispose();
//   }
// }
//
// // Bottom sheet de détails de produit (à compléter)
// class ProductDetailsSheet extends StatelessWidget {
//   final Product product;
//
//   const ProductDetailsSheet({required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Text('Détails de ${product.name}'),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/low_stock_alert.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import 'product_detail_screen.dart';
// lib/screens/products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/low_stock_alert.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import 'product_detail_screen.dart';

/// Écran principal pour la gestion des produits.
/// Peut afficher tous les produits ou uniquement ceux en stock faible (alerte).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import 'product_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import 'product_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showFilters = false;

  // Options de tri (à implémenter côté API si nécessaire)
  final Map<String, String> _sortOptions = {
    'name': 'Nom',
    'price': 'Prix',
    'quantity': 'Quantité',
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProductProvider>(context, listen: false).loadProducts());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.search = _searchController.text;
    provider.loadProducts(page: 1);
  }

  void _applyFilters() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.loadProducts(page: 1);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _showFilters = false;
    });

    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.search = '';
    provider.lowStockFilter = false;
    provider.loadProducts(page: 1);
  }

  void _scanBarcode() async {
    // Simulation du scan de code-barres
    try {
      // Simuler un code-barres scanné
      const String simulatedBarcode = '1234567890123';

      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.search = simulatedBarcode;
      _searchController.text = simulatedBarcode;
      provider.loadProducts(page: 1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code-barres scanné: $simulatedBarcode'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du scan du code-barres'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Méthode pour obtenir les catégories (à adapter selon votre implémentation)
  List<Map<String, dynamic>> _getCategories() {
    // Remplacez ceci par votre logique de récupération des catégories
    return [
      {'id': '1', 'name': 'Encre'},
      {'id': '2', 'name': 'Papeterie'},
      {'id': '3', 'name': 'Ordinateurs'},
      {'id': '4', 'name': 'Périphériques'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = _getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Produits'),
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Iconsax.filter),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: 'Filtres',
          ),
          IconButton(
            icon: Icon(Iconsax.scan_barcode),
            onPressed: _scanBarcode,
            tooltip: 'Scanner un code-barres',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, code-barres...',
                prefixIcon: Icon(Iconsax.search_normal, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Iconsax.close_circle, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          // Filtres (expandable)
          if (_showFilters) ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Filtres', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Spacer(),
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text('Réinitialiser', style: TextStyle(color: Color(0xFF2196F3))),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Filtre stock bas
                  Row(
                    children: [
                      Checkbox(
                        value: productProvider.lowStockFilter,
                        onChanged: (value) {
                          final provider = Provider.of<ProductProvider>(context, listen: false);
                          provider.lowStockFilter = value ?? false;
                          provider.loadProducts(page: 1);
                        },
                      ),
                      Text('Stock faible seulement'),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Indicateurs de filtres actifs
          if (productProvider.lowStockFilter || _searchController.text.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue[50],
              child: Row(
                children: [
                  Icon(Iconsax.filter, size: 16, color: Color(0xFF2196F3)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getActiveFiltersText(productProvider),
                      style: TextStyle(fontSize: 12, color: Color(0xFF2196F3)),
                    ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text('Effacer', style: TextStyle(fontSize: 12, color: Color(0xFF2196F3))),
                  ),
                ],
              ),
            ),

          // Compteur de résultats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${productProvider.products.length} produit(s)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Spacer(),
                if (productProvider.loading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // Liste des produits
          Expanded(
            child: productProvider.loading && productProvider.products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : productProvider.products.isEmpty
                ? _buildEmptyState(productProvider)
                : RefreshIndicator(
              onRefresh: () async {
                await productProvider.loadProducts(page: 1);
              },
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 16),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
          ),

          // Pagination
          if (productProvider.totalPages > 1) _buildPagination(productProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
        },
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
        child: Icon(Iconsax.add),
      ),
    );
  }

  Widget _buildEmptyState(ProductProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.box, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Aucun produit trouvé',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            provider.search.isNotEmpty || provider.lowStockFilter
                ? 'Modifiez vos critères de recherche ou de filtrage'
                : 'Commencez par ajouter votre premier produit',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 16),
          if (provider.search.isNotEmpty || provider.lowStockFilter)
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2196F3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Réinitialiser les filtres'),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductFormScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2196F3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Ajouter un produit'),
            ),
        ],
      ),
    );
  }

  Widget _buildPagination(ProductProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Iconsax.arrow_left),
            onPressed: provider.currentPage > 1
                ? () => provider.loadProducts(page: provider.currentPage - 1)
                : null,
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Page ${provider.currentPage} / ${provider.totalPages}',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 12),
          IconButton(
            icon: Icon(Iconsax.arrow_right),
            onPressed: provider.currentPage < provider.totalPages
                ? () => provider.loadProducts(page: provider.currentPage + 1)
                : null,
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveFiltersText(ProductProvider provider) {
    List<String> activeFilters = [];

    if (provider.lowStockFilter) {
      activeFilters.add('Stock faible');
    }

    if (provider.search.isNotEmpty) {
      activeFilters.add('Recherche: "${provider.search}"');
    }

    return activeFilters.join(' • ');
  }
}