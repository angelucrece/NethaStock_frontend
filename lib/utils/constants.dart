import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
class AppConstants {
  static const String appName = 'NethaStock';
  static const String apiBaseUrl = 'http://localhost:3000/api';
  //tatic const String apiBaseUrl = "http://127.0.0.1:8000/api"; // ton API
  //static const String tokenKey = "auth_token"; // clé pour le token JWT
  static const String refreshTokenKey = "refresh_token"; // clé pour le refresh token
  //static const String userKey = "user"; // clé pour les infos utilisateur

  // Routes
  // POST /api/auth/login - Connexion utilisateur
  static const String loginRoute = '/auth/login';
  // POST /api/auth/register - Création d'un nouvel utilisateur (Admin uniquement)
  static const String registerRoute=' /auth/register';
  // GET /api/auth/verify - Vérification de la validité du token
  static const String verifyRoute=' /auth/register';
  // POST /api/auth/refresh - Renouvellement du token
  //static const String refreshRoute=' /auth/register';
  // GET /api/categories - Liste toutes les catégories,     Créer une nouvelle catégorie (Admin uniquement)
  static const String categoriesRoute = '/api/categories';
  // GET /api/categories/:id - Détails d'une catégorie ,Modifier une catégorie (Admin uniquement),  Supprimer une catégorie (Admin uniquement)
  static const String categorieRoute = '/api/categories/:id';
  // GET /api/movements - Historique des mouvements avec pagination et filtres,POST /api/movements - Créer un nouveau mouvement de stock
  static const String movementsRoute = '/api/movements';
  // GET /api/movements/pending - Mouvements en attente de validation (Admin)
  static const String movementRoute = '/api/movements/pending';
  // PUT /api/movements/:id/validate - Valider un mouvement (Admin)
  // GET /api/movements/stats - Statistiques des mouvements
  static const String dashboardRoute = '/dashboard';
  // GET /api/products - Liste des produits avec recherche et pagination,  // POST /api/products - Créer un nouveau produit (Admin uniquement)
  static const String productsRoute = '/api/products';
  // GET /api/products/:id - Détails d'un produit
  static const String productRoute = '/api/products/:id';
  // PUT /api/products/:id - Modifier un produit (Admin uniquement)  // DELETE /api/products/:id - Supprimer un produit (Admin uniquement)

// GET /api/products/barcode/:barcode - Recherche par code-barres

// GET /api/products/low-stock - Produits en stock faible
  //static const String movementsRoute = '/movements';
  // GET /api/users/me/profile - Profil de l'utilisateur connecté
  static const String profileRoute = '/api/users/me/profile';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // Default values
  static const int defaultStockThreshold = 10;
  static const double defaultProductPrice = 0.0;
}

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFF44336);
  static const Color dark = Color(0xFF343A40);
  static const Color light = Color(0xFFF8F9FA);
  // Définition des couleurs de l'application (corrige l'erreur avecOpacity)
  final Color _primaryColor = Color(0xFF2196F3);
  final Color _secondaryColor = Color(0xFFFF9800);
  final Color _accentColor = Color(0xFFFF9800);
  final Color _successColor = Color(0xFF10B981);
  final Color _warningColor = Color(0xFFF59E0B);
  final Color _dangerColor = Color(0xFFEF4444);
  final Color _infoColor = Color(0xFF8B5CF6);
}

class AppIcons {
  static const String dashboard = 'assets/icons/dashboard.png';
  static const String products = 'assets/icons/products.png';
  static const String movements = 'assets/icons/movements.png';
  static const String categories = 'assets/icons/categories.png';
  static const String profile = 'assets/icons/profile.png';
  static const String scanner = 'assets/icons/scanner.png';
}