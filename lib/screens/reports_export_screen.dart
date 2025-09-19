// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ReportsExportScreen extends StatelessWidget {
//   final String baseUrl;
//
//   ReportsExportScreen({required this.baseUrl});
//
//   void _exportStockCSV() async {
//     final url = Uri.parse('$baseUrl/reports/stock?format=csv');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Impossible de lancer $url';
//     }
//   }
//
//   void _exportMovementsCSV() async {
//     final url = Uri.parse('$baseUrl/reports/movements?format=csv');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Impossible de lancer $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exporter un rapport')),
//       body: ListView(
//         padding: EdgeInsets.all(10),
//         children: [
//           Card(
//             child: ListTile(
//               title: Text('Exporter Stock (CSV)'),
//               trailing: Icon(Icons.download),
//               onTap: _exportStockCSV,
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Exporter Mouvements (CSV)'),
//               trailing: Icon(Icons.download),
//               onTap: _exportMovementsCSV,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../services/api_service.dart';

class ReportsExportScreen extends StatelessWidget {
  final String baseUrl;

  ReportsExportScreen({required this.baseUrl});

  // Fonction générique pour télécharger et ouvrir le rapport
  Future<void> downloadAndOpenReport(BuildContext context, String endpoint, String fileName, String format) async {
    try {
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName.$format';

      // Téléchargement du fichier
      await dio.download(
        '$baseUrl/api/reports/$endpoint?format=$format',
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          // headers: await ApiService().headers(), // décommente si besoin d'auth
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Téléchargement terminé : $filePath")),
      );

      // Ouverture du fichier
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Impossible d’ouvrir le fichier : ${result.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur téléchargement ou ouverture: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exporter Rapports")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                downloadAndOpenReport(context, 'stock', 'rapport_stock', 'csv');
              },
              child: Text("Exporter Stock (CSV)"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                downloadAndOpenReport(context, 'movements', 'rapport_mouvements', 'csv');
              },
              child: Text("Exporter Mouvements (CSV)"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                downloadAndOpenReport(context, 'analytics', 'rapport_analytics', 'csv');
              },
              child: Text("Exporter Analytics (CSV)"),
            ),
          ],
        ),
      ),
    );
  }
}
