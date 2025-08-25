// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import '../models/user.dart';
// import '../services/api_service.dart';
// import '../services/local_storage.dart';
// import 'package:nethastock/services/api_service.dart';
//
// class AuthProvider with ChangeNotifier {
//   User? _user;
//   bool _isLoading = false;
//   String? _error;
//
//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _user != null;
//
//   AuthProvider() {
//     _loadUserFromStorage();
//   }
//
//   Future<void> _loadUserFromStorage() async {
//     try {
//       final userData = await LocalStorage().getUserData();
//       if (userData != null) {
//         final userJson = json.decode(userData);
//         _user = User.fromJson(userJson);
//         notifyListeners();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Erreur lors du chargement de l\'utilisateur: $e');
//       }
//     }
//   }
//
//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().login(email, password);
//
//       if (response.success) {
//         _user = response.data;
//         await LocalStorage().setUserData(json.encode(_user!.toJson()));
//         _error = null;
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
//       _error = 'Erreur de connexion: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     _user = null;
//     _error = null;
//     await LocalStorage().clearUserData();
//     await LocalStorage().removeToken();
//     notifyListeners();
//   }
//
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';

class AuthProvider with ChangeNotifier {
  /// Provider pour la gestion de l'authentification des utilisateurs
  /// Gère la connexion, déconnexion et la persistance de la session

  User? _user; // Utilisateur actuellement connecté
  bool _isLoading = false; // État de chargement pour les opérations d'authentification
  String? _error; // Message d'erreur éventuel

  // Getter pour accéder à l'utilisateur connecté
  User? get user => _user;

  // Getter pour vérifier l'état de chargement
  bool get isLoading => _isLoading;

  // Getter pour accéder aux messages d'erreur
  String? get error => _error;

  // Getter pour vérifier si un utilisateur est authentifié
  bool get isAuthenticated => _user != null;

  // Getter pour vérifier si l'utilisateur est administrateur
  bool get isAdmin => _user?.role == 'administrateur';

  // Getter pour vérifier si l'utilisateur est magasinier
  bool get isMagasinier => _user?.role == 'magasinier';

  /// Constructeur qui charge automatiquement l'utilisateur depuis le stockage local
  AuthProvider() {
    _loadUserFromStorage();
  }

  /// Charge l'utilisateur depuis le stockage local au démarrage de l'application
  Future<void> _loadUserFromStorage() async {
    try {
      final userData = await LocalStorage().getUserData();
      if (userData != null) {
        final userJson = json.decode(userData);
        _user = User.fromJson(userJson);
        notifyListeners(); // Notifie les écouteurs du changement
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement de l\'utilisateur: $e');
      }
    }
  }

  /// Méthode de connexion d'un utilisateur
  /// [email] : Email de l'utilisateur
  /// [password] : Mot de passe de l'utilisateur
  /// Retourne true si la connexion réussit, false sinon
  Future<bool> login(String email, String password) async {
    _isLoading = true; // Active l'indicateur de chargement
    _error = null; // Réinitialise les erreurs précédentes
    notifyListeners(); // Notifie les écouteurs du changement d'état

    try {
      // Appel au service API pour la connexion
      final response = await ApiService().login(email, password);

      if (response.success && response.data != null) {
        _user = response.data; // Stocke l'utilisateur connecté

        // Persiste les données utilisateur dans le stockage local
        await LocalStorage().setUserData(json.encode(_user!.toJson()));
        await LocalStorage().setToken(response.data!.token!);

        _error = null; // Réinitialise les erreurs
        _isLoading = false; // Désactive le chargement
        notifyListeners(); // Notifie les écouteurs

        return true; // Connexion réussie
      } else {
        // Stocke le message d'erreur de l'API
        _error = response.message ?? 'Erreur de connexion';
        _isLoading = false;
        notifyListeners();
        return false; // Connexion échouée
      }
    } catch (e) {
      // Gestion des erreurs de réseau ou autres exceptions
      _error = 'Erreur de connexion: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Méthode de déconnexion de l'utilisateur
  /// Supprime toutes les données de session et notifie les écouteurs
  Future<void> logout() async {
    _user = null; // Supprime l'utilisateur
    _error = null; // Réinitialise les erreurs

    // Nettoie le stockage local
    await LocalStorage().clearUserData();
    await LocalStorage().removeToken();

    notifyListeners(); // Notifie les écouteurs de la déconnexion
  }

  /// Méthode pour effacer les messages d'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Méthode pour mettre à jour les informations du profil utilisateur
  /// [updatedUser] : Utilisateur avec les informations mises à jour
  Future<bool> updateProfile(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().updateUser(updatedUser);

      if (response.success && response.data != null) {
        _user = response.data; // Met à jour l'utilisateur

        // Met à jour le stockage local
        await LocalStorage().setUserData(json.encode(_user!.toJson()));

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
      _error = 'Erreur de mise à jour du profil: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}