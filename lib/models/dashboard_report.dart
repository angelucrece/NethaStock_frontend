// class DashboardReport {
//   final Map<String, dynamic> stockOverview;
//   final Map<String, dynamic> movementSummary;
//   final List<dynamic> recentMovements;
//   final List<dynamic> lowStockAlerts;
//   final String userRole;
//   final String lastUpdated;
//
//   DashboardReport({
//     required this.stockOverview,
//     required this.movementSummary,
//     required this.recentMovements,
//     required this.lowStockAlerts,
//     required this.userRole,
//     required this.lastUpdated,
//   });
//
//   factory DashboardReport.fromJson(Map<String, dynamic> json) {
//     final data = json['data'];
//     return DashboardReport(
//       stockOverview: data['stockOverview'] ?? {},
//       movementSummary: data['movementSummary'] ?? {},
//       recentMovements: data['recentMovements'] ?? [],
//       lowStockAlerts: data['lowStockAlerts'] ?? [],
//       userRole: data['userRole'] ?? "",
//       lastUpdated: data['lastUpdated'] ?? "",
//     );
//   }
// }
