// import 'package:flutter/foundation.dart';
// import '../models/product.dart';
// import '../services/api_service.dart';
// import 'package:nethastock/services/api_service.dart';
//
// class ProductProvider with ChangeNotifier {
//   List<Product> _products = [];
//   List<Product> _filteredProducts = [];
//   bool _isLoading = false;
//   String? _error;
//   String _searchQuery = '';
//   int? _categoryFilter;
//
//   List<Product> get products => _filteredProducts;
//   List<Product> get allProducts => _products;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   List<Product> get lowStockProducts {
//     return _products.where((product) => product.isLowStock).toList();
//   }
//
//   ProductProvider() {
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().getProducts(categoryId: _categoryFilter);
//
//       if (response.success) {
//         _products = response.data ?? [];
//         _applyFilters();
//         _error = null;
//       } else {
//         _error = response.message;
//       }
//     } catch (e) {
//       _error = 'Erreur de chargement des produits: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<bool> addProduct(Product product) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().createProduct(product);
//
//       if (response.success) {
//         _products.add(response.data!);
//         _applyFilters();
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = response.message;
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Erreur d\'ajout du produit: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<bool> updateProduct(Product product) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().updateProduct(product);
//
//       if (response.success) {
//         final index = _products.indexWhere((p) => p.id == product.id);
//         if (index != -1) {
//           _products[index] = response.data!;
//           _applyFilters();
//         }
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = response.message;
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Erreur de mise à jour du produit: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<bool> deleteProduct(int productId) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().deleteProduct(productId);
//
//       if (response.success) {
//         _products.removeWhere((p) => p.id == productId);
//         _applyFilters();
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = response.message;
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Erreur de suppression du produit: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   void setSearchQuery(String query) {
//     _searchQuery = query;
//     _applyFilters();
//   }
//
//   void setCategoryFilter(int? categoryId) {
//     _categoryFilter = categoryId;
//     _applyFilters();
//   }
//
//   void _applyFilters() {
//     _filteredProducts = _products.where((product) {
//       final matchesSearch = _searchQuery.isEmpty ||
//           product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           product.code.toLowerCase().contains(_searchQuery.toLowerCase());
//
//       final matchesCategory = _categoryFilter == null ||
//           product.categoryId == _categoryFilter;
//
//       return matchesSearch && matchesCategory;
//     }).toList();
//
//     notifyListeners();
//   }
//
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
//
//   Product? getProductById(int id) {
//     return _products.firstWhere((p) => p.id == id);
//   }
// }

// providers/product_provider.dart
// providers/product_provider.dart
// Import des packages et fichiers nécessaires
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
//import '../services/api_services.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  int currentPage = 1;
  int totalPages = 1;
  bool _loading = false;
  String search = '';
  bool lowStockFilter = false;

  List<Product> get products => _products;
  bool get loading => _loading;
  List<dynamic> _lowStockAlerts = [];
  List<dynamic> get lowStockAlerts => _lowStockAlerts;

  Future<void> loadLowStockAlerts() async {
    final response = await ApiService().getLowStockAlerts();
    if (response.success && response.data != null) {
      _lowStockAlerts = response.data!;
    } else {
      _lowStockAlerts = [];
    }
    notifyListeners();
  }


  Future<void> loadProducts({int page = 1}) async {
    _loading = true;
    notifyListeners();
    try {
      final result = await ApiService().fetchProducts(
        search: search,
        page: page,
        lowStock: lowStockFilter,
      );
      _products = result['products'];
      currentPage = result['pagination']['page'];
      totalPages = result['pagination']['totalPages'];
    } catch (e) {
      debugPrint('Erreur chargement produits: $e');
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    await ApiService().deleteProduct(id);
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Future<void> createOrUpdateProduct(Product product, {bool isUpdate = false}) async {
    if (isUpdate) {
      final updated = await ApiService().updateProduct(product.id, {
        'name': product.name,
        'barcode': product.barcode,
        'price': product.price,
        'quantity': product.quantity,
        'threshold': product.threshold,
        'categoryId': product.categoryId,
        'description': product.description,
        'purchasePrice': product.purchasePrice,
        'imageUrl': product.imageUrl,
      });
      final index = _products.indexWhere((p) => p.id == updated.id);
      if (index != -1) _products[index] = updated;
    } else {
      final created = await ApiService().createProduct({
        'name': product.name,
        'barcode': product.barcode,
        'price': product.price,
        'quantity': product.quantity,
        'threshold': product.threshold,
        'categoryId': product.categoryId,
        'description': product.description,
        'purchasePrice': product.purchasePrice,
        'imageUrl': product.imageUrl,
      });
      _products.add(created);
    }
    notifyListeners();
  }
}
