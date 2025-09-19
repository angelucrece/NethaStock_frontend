// import 'package:flutter/material.dart';
// import '../models/movement_report.dart';
// import '../models/reports.dart';
// import '../services/reports_api_service.dart';
//
// class MovementReportProvider extends ChangeNotifier {
//   final ReportsApiService apiService;
//
//   MovementReportProvider({required this.apiService});
//
//   List<MovementReport> _reports = [];
//   bool _loading = false;
//   String? _error;
//
//   List<MovementReport> get reports => _reports;
//   bool get loading => _loading;
//   String? get error => _error;
//
//   Future<void> fetchReports() async {
//     _loading = true;
//     notifyListeners();
//
//     try {
//       _reports = await apiService.getMovementsReport();
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//     }
//
//     _loading = false;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../services/api_service.dart';
import '../models/api_response.dart';

class MovementReportProvider with ChangeNotifier {
  List<Movement> _reports = [];
  bool _loading = false;
  String? _error;

  List<Movement> get reports => _reports;
  bool get loading => _loading;
  String? get error => _error;

  /// Charge le rapport des mouvements depuis l'API
  Future<void> fetchReports({
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getMovements(
        type: type,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.success) {
        _reports = response.data ?? [];
        _error = null;
      } else {
        _reports = [];
        _error = response.message ?? 'Erreur inconnue';
      }
    } catch (e) {
      _reports = [];
      _error = 'Erreur lors du chargement des mouvements: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Filtre local par type
  void filterByType(String type) {
    _reports = _reports.where((m) => m.type == type).toList();
    notifyListeners();
  }

  /// Réinitialise le filtre
  void resetFilter() {
    fetchReports();
  }
}

