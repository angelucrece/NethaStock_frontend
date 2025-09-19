import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onFilter;

  FilterWidget({this.startDate, this.endDate, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          child: Text('Start Date'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: startDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) onFilter(picked, endDate);
          },
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Text('End Date'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: endDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) onFilter(startDate, picked);
          },
        ),
      ],
    );
  }
}
