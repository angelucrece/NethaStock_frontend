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
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  int? _categoryFilter;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get lowStockProducts => _products.where((p) => p.isLowStock).toList();

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getProducts(categoryId: _categoryFilter);

      if (response.success) {
        _products = response.data ?? [];
        _applyFilters();
        _error = null;

        // Vérifier les alertes stock au chargement
        _checkStockAlerts();
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Erreur de chargement des produits: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void _applyFilters() {
    // Implémentez votre logique de filtrage ici
    notifyListeners();
  }

  Future<bool> updateProductStock(int productId, int newQuantity, String operationType) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      final updatedProduct = product.copyWith(quantity: newQuantity);

      final response = await ApiService().updateProduct(updatedProduct);

      if (response.success) {
        final index = _products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          _products[index] = response.data!;
          _applyFilters();

          // Vérifier les alertes après mise à jour
          _checkStockAlertsForProduct(response.data!);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _checkStockAlerts() {
    for (final product in _products) {
      _checkStockAlertsForProduct(product);
    }
  }

  void _checkStockAlertsForProduct(Product product) {
    if (product.isLowStock) {
      NotificationService().showStockAlert(
          product.name,
          product.quantity,
          product.threshold
      );
    }
  }

// ... reste des méthodes existantes ...
}