import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ReportTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;

  const ReportTable({required this.headers, required this.rows, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
        rows: rows.map(
              (r) => DataRow(cells: r.map((c) => DataCell(Text(c.toString()))).toList()),
        ).toList(),
      ),
    );
  }
}
