// import 'package:flutter/material.dart';
// import '../models/movement.dart';
// import '../utils/helpers.dart';
//
// class MovementItem extends StatelessWidget {
//   final Movement movement;
//   final VoidCallback? onTap;
//
//   const MovementItem({
//     Key? key,
//     required this.movement,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isEntry = movement.isEntry;
//     final isPending = movement.isPending;
//
//     return Card(
//       elevation: 1,
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
//       child: ListTile(
//         onTap: onTap,
//         leading: Icon(
//           isEntry ? Icons.arrow_downward : Icons.arrow_upward,
//           color: isEntry ? Colors.green : Colors.orange,
//         ),
//         title: Text(
//           '${isEntry ? 'Entrée' : 'Sortie'} de ${movement.quantity} unités',
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         subtitle: Text(
//           AppHelpers.formatDate(movement.date),
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//         trailing: Chip(
//           label: Text(
//             movement.status.toUpperCase(),
//             style: const TextStyle(fontSize: 12, color: Colors.white),
//           ),
//           backgroundColor: _getStatusColor(movement.status),
//         ),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'validated':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }


// widgets/movement_item.dart
import 'package:flutter/material.dart';
import '../models/movement.dart'; // Import important

class MovementItem extends StatelessWidget {
  final Movement movement; // ✅ Changer de Map<String, dynamic> à Movement
  final VoidCallback? onTap;

  const MovementItem({
    Key? key,
    required this.movement, // ✅ Maintenant accepte un Movement
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Utilisez les propriétés de l'objet Movement
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: movement.color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: movement.color, width: 1.5),
          ),
          child: Icon(
            movement.icon,
            color: movement.color,
            size: 20,
          ),
        ),
        title: Text(
          movement.productName.isNotEmpty
              ? movement.productName
              : 'Produit ${movement.productId}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2),
            Text(
              'Quantité: ${movement.quantity}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              '${movement.formattedDate} ${movement.formattedTime}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: movement.statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: movement.statusColor, width: 1),
          ),
          child: Text(
            movement.statusText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: movement.statusColor,
            ),
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}