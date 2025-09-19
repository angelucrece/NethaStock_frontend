import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
// import '../providers/report_provider.dart';
// // import '../providers/stock_provider.dart';
// // import '../providers/movement_provider.dart';
// // import '../providers/analytics_provider.dart';
// // import '../providers/dashboard_provider.dart';
//
// class ReportsOverviewScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final stockProvider = Provider.of<StockProvider>(context);
//     final movementProvider = Provider.of<MovementProvider>(context);
//     final analyticsProvider = Provider.of<AnalyticsProvider>(context);
//     final dashboardProvider = Provider.of<DashboardProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Tous les rapports')),
//       body: ListView(
//         padding: EdgeInsets.all(10),
//         children: [
//           Card(
//             child: ListTile(
//               title: Text('Stock'),
//               subtitle: Text('Total produits: ${stockProvider.report?.summary.totalProducts ?? '...'}'),
//               trailing: Icon(Icons.arrow_forward),
//               onTap: () => Navigator.pushNamed(context, '/reports/stock'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Mouvements'),
//               subtitle: Text('Total mouvements: ${movementProvider.report?.summary.totalMovements ?? '...'}'),
//               trailing: Icon(Icons.arrow_forward),
//               onTap: () => Navigator.pushNamed(context, '/reports/movements'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Analytics'),
//               subtitle: Text('Période: ${analyticsProvider.report?.period ?? '...'} jours'),
//               trailing: Icon(Icons.arrow_forward),
//               onTap: () => Navigator.pushNamed(context, '/reports/analytics'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Dashboard'),
//               subtitle: Text('Dernière mise à jour: ${dashboardProvider.data?.lastUpdated ?? '...'}'),
//               trailing: Icon(Icons.arrow_forward),
//               onTap: () => Navigator.pushNamed(context, '/reports/dashboard'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movement_provider.dart';
import '../providers/movement_report_provide.dart';
import '../providers/stock_report_provider.dart';
//import '../providers/movement_report_provider.dart';
import '../providers/analytics_report_provider.dart';
import '../providers/dashboard_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_report_provider.dart';
import '../widgets/report_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/report_table.dart';
import '../providers/stock_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_report_provider.dart';
import '../providers/movement_report_provide.dart';
import '../widgets/report_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/movement.dart';
import '../providers/stock_report_provider.dart';
import '../providers/movement_report_provide.dart';
import '../providers/analytics_report_provider.dart';
import '../providers/dashboard_report_provider.dart';
import '../widgets/report_table.dart';

class ReportsViewScreen extends StatefulWidget {
  const ReportsViewScreen({super.key});

  @override
  State<ReportsViewScreen> createState() => _ReportsViewScreenState();
}

class _ReportsViewScreenState extends State<ReportsViewScreen> {
  String _selectedReportType = "stock";

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    switch (_selectedReportType) {
      case "stock":
        Provider.of<StockReportProvider>(context, listen: false).fetchReports();
        break;
      case "movements":
        Provider.of<MovementReportProvider>(context, listen: false).fetchReports();
        break;
      case "analytics":
        Provider.of<AnalyticsReportProvider>(context, listen: false).fetchReport();
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_selectedReportType) {
      case "stock":
        final provider = Provider.of<StockReportProvider>(context);
        if (provider.loading) return const Center(child: CircularProgressIndicator());
        if (provider.error != null) return Center(child: Text(provider.error!));

        content = ReportTable(
          headers: ["Produit", "Code-barres", "Catégorie", "Quantité", "Seuil", "Prix", "Valeur stock", "Alerte"],
          rows: provider.reports.map((Product p) => [
            p.name,
            p.barcode,
            p.categoryName,
            p.quantity.toString(),
            p.threshold.toString(),
            p.price.toStringAsFixed(2),
            (p.price * p.quantity).toStringAsFixed(2),
            p.lowStock ? "⚠️" : "",
          ]).toList(),
        );
        break;

      case "movements":
        final provider = Provider.of<MovementReportProvider>(context);
        if (provider.loading) return const Center(child: CircularProgressIndicator());
        if (provider.error != null) return Center(child: Text(provider.error!));

        content = ReportTable(
          headers: ["Date", "Type", "Produit", "Quantité", "Utilisateur", "Statut", "Motif"],
          rows: provider.reports.map((Movement m) => [
            m.formattedDate,
            m.typeText,
            m.productName,
            m.quantity.toString(),
            m.userName ?? '',
            m.statusText,
            m.motif ?? '',
          ]).toList(),
        );
        break;

      case "analytics":
        final provider = Provider.of<AnalyticsReportProvider>(context);
        if (provider.loading) return const Center(child: CircularProgressIndicator());
        if (provider.error != null) return Center(child: Text(provider.error!));

        final report = provider.report!;
        content = SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock Overview
              const Text("📦 Stock Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Total produits: ${report.stockOverview['total_products']}"),
                      Text("Valeur stock: ${report.stockOverview['total_stock_value']}"),
                      Text("Produits en faible stock: ${report.stockOverview['low_stock_count']}"),
                      Text("Produits épuisés: ${report.stockOverview['out_of_stock_count']}"),
                      Text("Quantité moyenne: ${report.stockOverview['avg_quantity']}"),
                    ],
                  ),
                ),
              ),
              // Movement Summary
              const SizedBox(height: 16),
              const Text("📊 Movement Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Total mouvements: ${report.movementSummary['total_movements']}"),
                      Text("Entrées: ${report.movementSummary['entries']}"),
                      Text("Sorties: ${report.movementSummary['exits']}"),
                      Text("En attente: ${report.movementSummary['pending']}"),
                      Text("Quantité entrée: ${report.movementSummary['total_entries_qty']}"),
                      Text("Quantité sortie: ${report.movementSummary['total_exits_qty']}"),
                    ],
                  ),
                ),
              ),
              // Top Products
              const SizedBox(height: 16),
              const Text("🏆 Top Produits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...report.topProducts.map((p) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(p['name']),
                  subtitle: Text("Code-barres: ${p['barcode']}"),
                  trailing: Text("Mouvements: ${p['movement_count']}, Qté: ${p['total_quantity']}"),
                ),
              )),
              // User Activity
              const SizedBox(height: 16),
              const Text("👤 User Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...report.userActivity.map((u) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text("${u['first_name']} ${u['last_name']}"),
                  subtitle: Text("Role: ${u['role']}"),
                  trailing: Text("Mouvements: ${u['movement_count']}"),
                ),
              )),
              // Daily Evolution
              const SizedBox(height: 16),
              const Text("📈 Daily Evolution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...report.dailyEvolution.map((d) => Card(
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: ListTile(
                  title: Text(d['date']),
                  subtitle: Text("Entrées: ${d['entries']} | Sorties: ${d['exits']}"),
                  trailing: Text("Qté Entrée: ${d['entryQuantity']} | Qté Sortie: ${d['exitQuantity']}"),
                ),
              )),
            ],
          ),
        );
        break;



      default:
        content = const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("📊 Voir les rapports")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedReportType,
              items: const [
                DropdownMenuItem(value: "stock", child: Text("Stock")),
                DropdownMenuItem(value: "movements", child: Text("Mouvements")),
                DropdownMenuItem(value: "analytics", child: Text("Analytics")),
                DropdownMenuItem(value: "dashboard", child: Text("Dashboard")),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedReportType = val!;
                  _loadReports();
                });
              },
              decoration: const InputDecoration(labelText: "Type de rapport"),
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}
