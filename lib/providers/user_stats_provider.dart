

//
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/user_stats.dart';
//
// class UserStatsProvider with ChangeNotifier {
//   UserStats? _stats;
//   bool _isLoading = false;
//   String? _error;
//
//   UserStats? get stats => _stats;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   Future<void> loadStats() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       _stats = await ApiService().fetchUserStats();
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
