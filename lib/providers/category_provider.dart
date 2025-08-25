import 'package:flutter/foundation.dart';
import '../models/category.dart' hide Category;
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getCategories();

      if (response.success) {
        //_categories = response.data ?? [];
        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Erreur de chargement des catégories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Category? getCategoryById(int id) {
    return _categories.firstWhere((c) => c.id == id);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

extension on Category {
  get id => null;
}