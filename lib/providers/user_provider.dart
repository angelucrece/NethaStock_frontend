import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
Map<String, dynamic> _userStats = {};
List<Map<String, dynamic>> _topUsers = [];

Map<String, dynamic> get userStats => _userStats;
List<Map<String, dynamic>> get topUsers => _topUsers;

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  User? currentUser;

  Map<String, dynamic> _userStats = {};
  List<User> _topUsers = [];

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<User> get activeUsers => _users.where((u) => u.isActive).toList();
  List<User> get inactiveUsers => _users.where((u) => !u.isActive).toList();
  List<User> get magasiniers => _users.where((u) => u.isMagasinier).toList();
  List<User> get administrators => _users.where((u) => u.isAdmin).toList();

  UserProvider() {
    fetchUsers();
  }

  /// Récupère tous les utilisateurs depuis l'API
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getUsers();
      if (response.success) {
        _users = response.data ?? [];
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

  /// Crée un utilisateur
  Future<bool> createUser(User user, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().createUser(user, password);
      if (response.success && response.data != null) {
        _users.add(response.data!);
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = 'Erreur création utilisateur: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Map<String, dynamic> get userStats => _userStats;
  List<User> get topUsers => _topUsers;


  // Récupérer les utilisateurs


  // Récupérer les statistiques
  Future<void> fetchUserStats() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService().fetchUserStats();
      _userStats = {
        'totalUsers': data['totalUsers'] ?? 0,
        'activeUsers': data['activeUsers'] ?? 0,
        'newUsers': data['activeThisMonth'] ?? 0,
      };
      _topUsers = (data['topUsers'] as List<dynamic>? ?? [])
          .map((u) => User.fromJson(u))
          .toList();
    } catch (e) {
      _error = 'Erreur fetch stats: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  /// Met à jour un utilisateur
  Future<bool> updateUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().updateUser(user);
      if (response.success && response.data != null) {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) _users[index] = response.data!;
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = 'Erreur mise à jour utilisateur: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Désactive un utilisateur
  Future<bool> deactivateUser(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().deactivateUser(userId);
      if (response.success) {
        final index = _users.indexWhere((u) => u.id == userId);
        if (index != -1) _users[index] = _users[index].copyWith(isActive: false);
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = 'Erreur désactivation utilisateur: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Réactive un utilisateur
  Future<bool> activateUser(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().activateUser(userId);
      if (response.success) {
        final index = _users.indexWhere((u) => u.id == userId);
        if (index != -1) _users[index] = _users[index].copyWith(isActive: true);
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = 'Erreur activation utilisateur: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Efface le message d'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Recherche des utilisateurs
  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;
    return _users.where((user) =>
    user.fullName.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase()) ||
        user.role.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Récupération des détails d’un utilisateur par ID
  final ApiService apiService = ApiService();
  Future<User?> getUserDetails(int userId) async {
    try {
      final response = await apiService.getUserById(userId);
      if (response.success && response.data != null) {
        return response.data;
      } else {
        throw Exception(response.message ?? "Impossible de charger l'utilisateur");
      }
    } catch (e) {
      throw Exception("Erreur de récupération des détails: $e");
    }
  }
}

