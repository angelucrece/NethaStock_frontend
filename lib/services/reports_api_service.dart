// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/stock_report.dart';
// import '../models/movement_report.dart';
// import '../models/analytics_report.dart';
// import '../models/dashboard_report.dart';
//
// class ReportsApiService {
//   final String baseUrl;
//   final String token;
//
//   ReportsApiService({required this.baseUrl, required this.token});
//
//   Future<List<StockReport>> getStockReport({bool lowStockOnly = false}) async {
//     final uri = Uri.parse("$baseUrl/reports/stock?lowStockOnly=$lowStockOnly");
//     final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List products = data["data"]["products"];
//       return products.map((e) => StockReport.fromJson(e)).toList();
//     } else {
//       throw Exception("Erreur API: ${response.statusCode}");
//     }
//   }
//
//   Future<List<MovementReport>> getMovementsReport() async {
//     final uri = Uri.parse("$baseUrl/reports/movements");
//     final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List movements = data["data"]["movements"];
//       return movements.map((e) => MovementReport.fromJson(e)).toList();
//     } else {
//       throw Exception("Erreur API: ${response.statusCode}");
//     }
//   }
//
//   Future<AnalyticsReport> getAnalyticsReport({int period = 30}) async {
//     final uri = Uri.parse("$baseUrl/reports/analytics?period=$period");
//     final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return AnalyticsReport.fromJson(data);
//     } else {
//       throw Exception("Erreur API: ${response.statusCode}");
//     }
//   }
//
//   Future<DashboardReport> getDashboardReport() async {
//     final uri = Uri.parse("$baseUrl/reports/dashboard");
//     final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return DashboardReport.fromJson(data);
//     } else {
//       throw Exception("Erreur API: ${response.statusCode}");
//     }
//   }
// }
