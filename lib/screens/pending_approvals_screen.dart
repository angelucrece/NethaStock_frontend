// screens/pending_approvals_screen.dart
import 'package:flutter/material.dart';
import 'package:nethastock/models/movement.dart';
import 'package:provider/provider.dart';
import '../providers/movement_provider.dart';
import '../widgets/movement_item.dart';

class PendingApprovalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movementProvider = Provider.of<MovementProvider>(context);
    final pendingMovements = movementProvider.movements.where((m) => m.status == 'pending').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Validations en Attente'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: pendingMovements.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: pendingMovements.length,
        itemBuilder: (context, index) => MovementItem(
          movement: pendingMovements[index],
          onTap: () => _showValidationDialog(context, pendingMovements[index]),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Aucune validation en attente', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('Toutes les opérations sont traitées', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  void _showValidationDialog(BuildContext context, Movement movement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Valider le mouvement'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Produit: ${movement.productId}'),
            Text('Type: ${movement.type == 'entry' ? 'Entrée' : 'Sortie'}'),
            Text('Quantité: ${movement.quantity}'),
            if (movement.motif != null) Text('Motif: ${movement.motif}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _validateMovement(context, movement, true),
            child: Text('Valider', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => _validateMovement(context, movement, false),
            child: Text('Rejeter', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _validateMovement(BuildContext context, Movement movement, bool approve) async {
    try {
      // Implémenter l'appel API pour la validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(approve ? 'Mouvement validé' : 'Mouvement rejeté')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la validation')),
      );
    }
  }
}