// import 'package:flutter/material.dart';
// import '../models/reports.dart';
// import '../services/api_service.dart';
//
// class DashboardProvider with ChangeNotifier {
//   DashboardData? _dashboardData;
//   bool _isLoading = false;
//   String? _error;
//
//   DashboardData? get dashboardData => _dashboardData;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   Future<void> fetchDashboardData() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       _dashboardData = (await ApiService().getDashboardData()) as DashboardData?;
//     } catch (e) {
//       _error = "Erreur récupération dashboard: $e";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
