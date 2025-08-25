import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../utils/helpers.dart';

class MovementItem extends StatelessWidget {
  final Movement movement;
  final VoidCallback? onTap;

  const MovementItem({
    Key? key,
    required this.movement,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEntry = movement.isEntry;
    final isPending = movement.isPending;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isEntry ? Icons.arrow_downward : Icons.arrow_upward,
          color: isEntry ? Colors.green : Colors.orange,
        ),
        title: Text(
          '${isEntry ? 'Entrée' : 'Sortie'} de ${movement.quantity} unités',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          AppHelpers.formatDate(movement.date),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Chip(
          label: Text(
            movement.status.toUpperCase(),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _getStatusColor(movement.status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'validated':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}