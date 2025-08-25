import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
class AppConstants {
  static const String appName = 'NethaStock';
  static const String apiBaseUrl = 'http://localhost:3000/api';

  // Routes
  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard';
  static const String productsRoute = '/products';
  static const String movementsRoute = '/movements';
  static const String categoriesRoute = '/categories';
  static const String profileRoute = '/profile';

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
}

class AppIcons {
  static const String dashboard = 'assets/icons/dashboard.png';
  static const String products = 'assets/icons/products.png';
  static const String movements = 'assets/icons/movements.png';
  static const String categories = 'assets/icons/categories.png';
  static const String profile = 'assets/icons/profile.png';
  static const String scanner = 'assets/icons/scanner.png';
}