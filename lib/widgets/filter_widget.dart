// widgets/filter_widget.dart
import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DateTime? startDate;
  final DateTime? endDate;
  final String movementType;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(String) onTypeChanged;
  final Function onApplyFilters;
  final Function onResetFilters;

  const FilterWidget({
    required this.formKey,
    required this.startDate,
    required this.endDate,
    required this.movementType,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onTypeChanged,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            DropdownButtonFormField(
              value: movementType,
              items: [
                DropdownMenuItem(value: 'all', child: Text('Tous les mouvements')),
                DropdownMenuItem(value: 'entry', child: Text('Entrées seulement')),
                DropdownMenuItem(value: 'exit', child: Text('Sorties seulement')),
              ],
              onChanged: (value) => onTypeChanged(value.toString()),
              decoration: InputDecoration(labelText: 'Type de mouvement'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      onStartDateChanged(date);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Date de début'),
                      child: Text(startDate != null
                          ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                          : 'Sélectionner'),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      onEndDateChanged(date);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Date de fin'),
                      child: Text(endDate != null
                          ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                          : 'Sélectionner'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onResetFilters(),
                    child: Text('Réinitialiser'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onApplyFilters(),
                    child: Text('Appliquer'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}