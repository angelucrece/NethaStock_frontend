import 'package:flutter/material.dart';
import '../models/reports.dart';
import '../services/api_service.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class StockReportProvider with ChangeNotifier {
  List<Product> _reports = [];
  bool _loading = false;
  String? _error;

  List<Product> get reports => _reports;
  bool get loading => _loading;
  String? get error => _error;

  /// Charge tous les produits pour le rapport de stock
  Future<void> fetchReports({bool lowStockOnly = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService().fetchProducts(
        search: '',
        page: 1,
        lowStock: lowStockOnly,
      );

      if (result['products'] != null) {
        // Comme fetchProducts renvoie déjà une List<Product>, on assigne directement
        _reports = List<Product>.from(result['products']);
      } else {
        _reports = [];
        _error = 'Aucun produit trouvé';
      }
    } catch (e) {
      _error = 'Erreur lors du chargement du rapport: $e';
      _reports = [];
    }
    finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Filtre uniquement les produits en stock faible
  void filterLowStock() {
    _reports = _reports.where((p) => p.lowStock).toList();
    notifyListeners();
  }

  /// Réinitialise le filtre
  void resetFilter() {
    fetchReports(lowStockOnly: false);
  }
}
