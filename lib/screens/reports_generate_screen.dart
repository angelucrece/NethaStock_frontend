// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/report_provider.dart';
// // import '../providers/stock_provider.dart';
// // import '../widgets/filters_widget.dart';
//
// class ReportsGenerateScreen extends StatefulWidget {
//   @override
//   _ReportsGenerateScreenState createState() => _ReportsGenerateScreenState();
// }
//
// class _ReportsGenerateScreenState extends State<ReportsGenerateScreen> {
//   bool lowStockOnly = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final stockProvider = Provider.of<StockProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Générer un rapport')),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             CheckboxListTile(
//               title: Text('Afficher seulement les stocks faibles'),
//               value: lowStockOnly,
//               onChanged: (val) {
//                 setState(() {
//                   lowStockOnly = val ?? false;
//                 });
//               },
//             ),
//             ElevatedButton(
//               child: Text('Générer'),
//               onPressed: () => stockProvider.fetchStockReport(lowStockOnly: lowStockOnly),
//             ),
//             SizedBox(height: 20),
//             stockProvider.loading
//                 ? CircularProgressIndicator()
//                 : Expanded(
//               child: ListView(
//                 children: stockProvider.report?.products.map((p) => ListTile(
//                   title: Text(p.name),
//                  // subtitle: Text('Quantité: ${p.quantity} - Statut: ${p.stockStatus}'),
//                 )).toList() ?? [],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movement_provider.dart';

class ReportsGenerateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovementProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Générer Rapports")),
      body: Center(
        child: provider.isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () {
            provider.fetchMovementReport(type: "entry");
          },
          child: Text("Générer Rapport Mouvements"),
        ),
      ),
    );
  }
}
