// import 'package:flutter/material.dart';
// import '../models/reports.dart';
// import '../services/api_service.dart';
//
// class AnalyticsProvider with ChangeNotifier {
//   AnalyticsReport? _analyticsReport;
//   bool _isLoading = false;
//   String? _error;
//
//   AnalyticsReport? get analyticsReport => _analyticsReport;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   Future<void> fetchAnalyticsReport({int period = 30}) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       _analyticsReport = await ApiService().getAnalyticsReport(period: period);
//     } catch (e) {
//       _error = "Erreur récupération analytics report: $e";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }


import 'package:flutter/material.dart';
import '../models/analytics_report.dart';
import '../services/api_service.dart';

class AnalyticsReportProvider with ChangeNotifier {
  AnalyticsReport? _report;
  bool _loading = false;
  String? _error;

  AnalyticsReport? get report => _report;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchReport({int periodDays = 30}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getAnalyticsReport(periodDays: periodDays);
      if (response.success && response.data != null) {
        _report = response.data;
      } else {
        _error = response.message ?? 'Erreur lors du chargement du rapport analytics';
      }
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

