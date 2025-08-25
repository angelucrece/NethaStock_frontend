import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  /// Provider pour la gestion des utilisateurs par l'administrateur
  /// Permet de créer, modifier, supprimer et lister les utilisateurs

  List<User> _users = []; // Liste de tous les utilisateurs
  bool _isLoading = false; // État de chargement
  String? _error; // Message d'erreur éventuel

  // Getter pour accéder à la liste des utilisateurs
  List<User> get users => _users;

  // Getter pour vérifier l'état de chargement
  bool get isLoading => _isLoading;

  // Getter pour accéder aux messages d'erreur
  String? get error => _error;

  // Getter pour les utilisateurs actifs seulement
  List<User> get activeUsers => _users.where((user) => user.isActive).toList();

  // Getter pour les utilisateurs inactifs
  List<User> get inactiveUsers => _users.where((user) => !user.isActive).toList();

  // Getter pour les magasiniers seulement
  List<User> get magasiniers => _users.where((user) => user.isMagasinier).toList();

  // Getter pour les administrateurs seulement
  List<User> get administrators => _users.where((user) => user.isAdmin).toList();

  /// Constructeur qui charge automatiquement les utilisateurs au démarrage
  UserProvider() {
    fetchUsers();
  }

  /// Récupère la liste des utilisateurs depuis l'API
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getUsers();

      if (response.success) {
        _users = response.data ?? [];
        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Erreur de chargement des utilisateurs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crée un nouvel utilisateur
  /// [user] : Utilisateur à créer avec mot de passe
  /// [password] : Mot de passe initial
  Future<bool> createUser(User user, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().createUser(user, password);

      if (response.success && response.data != null) {
        _users.add(response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur de création d\'utilisateur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Met à jour un utilisateur existant
  /// [user] : Utilisateur avec les nouvelles données
  Future<bool> updateUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().updateUser(user);

      if (response.success && response.data != null) {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = response.data!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur de mise à jour d\'utilisateur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Désactive un utilisateur
  /// [userId] : ID de l'utilisateur à désactiver
  Future<bool> deactivateUser(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().deactivateUser(userId as String);

      if (response.success) {
        final index = _users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          _users[index] = _users[index].copyWith(isActive: false);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur de désactivation d\'utilisateur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Réactive un utilisateur
  /// [userId] : ID de l'utilisateur à réactiver
  Future<bool> activateUser(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().activateUser(userId as String);

      if (response.success) {
        final index = _users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          _users[index] = _users[index].copyWith(isActive: true);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur d\'activation d\'utilisateur: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Efface les messages d'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Recherche des utilisateurs par nom, email ou rôle
  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;

    return _users.where((user) {
      return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()) ||
          user.role.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}