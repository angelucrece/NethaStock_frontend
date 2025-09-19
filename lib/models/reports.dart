// import 'dart:convert';
//
// /// ✅ Rapport Stock
// class StockReport {
//   final int totalProducts;
//   final int lowStockCount;
//   final List<dynamic> details;
//
//   StockReport({
//     required this.totalProducts,
//     required this.lowStockCount,
//     required this.details,
//   });
//
//   factory StockReport.fromJson(Map<String, dynamic> json) {
//     return StockReport(
//       totalProducts: json['totalProducts'] ?? 0,
//       lowStockCount: json['lowStockCount'] ?? 0,
//       details: json['details'] ?? [],
//     );
//   }
// }
//
// /// ✅ Rapport Mouvements
// class MovementReport {
//   final int totalMovements;
//   final List<dynamic> entries;
//   final List<dynamic> exits;
//
//   MovementReport({
//     required this.totalMovements,
//     required this.entries,
//     required this.exits,
//   });
//
//   factory MovementReport.fromJson(Map<String, dynamic> json) {
//     return MovementReport(
//       totalMovements: json['totalMovements'] ?? 0,
//       entries: json['entries'] ?? [],
//       exits: json['exits'] ?? [],
//     );
//   }
// }
//
// /// ✅ Rapport Analytics
// class AnalyticsReport {
//   final int totalSales;
//   final int totalPurchases;
//   final double growthRate;
//
//   AnalyticsReport({
//     required this.totalSales,
//     required this.totalPurchases,
//     required this.growthRate,
//   });
//
//   factory AnalyticsReport.fromJson(Map<String, dynamic> json) {
//     return AnalyticsReport(
//       totalSales: json['totalSales'] ?? 0,
//       totalPurchases: json['totalPurchases'] ?? 0,
//       growthRate: (json['growthRate'] ?? 0).toDouble(),
//     );
//   }
//
//   get period => null;
// }
//
// /// ✅ Dashboard Data
// class DashboardData {
//   final int totalStock;
//   final int totalMovements;
//   final int alerts;
//
//   DashboardData({
//     required this.totalStock,
//     required this.totalMovements,
//     required this.alerts,
//   });
//
//   factory DashboardData.fromJson(Map<String, dynamic> json) {
//     return DashboardData(
//       totalStock: json['totalStock'] ?? 0,
//       totalMovements: json['totalMovements'] ?? 0,
//       alerts: json['alerts'] ?? 0,
//     );
//   }
// }
