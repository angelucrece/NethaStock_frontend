import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Charger toutes les catégories
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getCategories();
      if (response.success) {
        _categories = response.data ?? [];
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Erreur de chargement: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Charger une catégorie avec ses détails
  Future<void> fetchCategoryDetails(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getCategoryById(id);
      if (response.success && response.data != null) {
        final index = _categories.indexWhere((c) => c.id == id);
        if (index != -1) {
          _categories[index] = response.data!;
        } else {
          _categories.add(response.data!);
        }
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Erreur API: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ajouter une nouvelle catégorie
  Future<bool> addCategory(Category category, String name) async {
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().createCategory(category, name);
      if (response.success && response.data != null) {
        _categories.add(response.data!);
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur lors de l\'ajout: $e';
      notifyListeners();
      return false;
    }
  }

  /// Mettre à jour une catégorie existante
  Future<bool> updateCategory(Category category) async {
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().updateCategory(category);
      if (response.success && response.data != null) {
        final index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = response.data!;
          notifyListeners();
        }
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur mise à jour: $e';
      notifyListeners();
      return false;
    }
  }

  /// Supprimer une catégorie
  Future<bool> deleteCategory(int categoryId) async {
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().deleteCategory(categoryId);
      if (response.success) {
        _categories.removeWhere((c) => c.id == categoryId);
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur suppression: $e';
      notifyListeners();
      return false;
    }
  }

  /// Nettoyer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
