// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/movement_provider.dart';
// import '../widgets/movement_item.dart';
//
// class MovementsScreen extends StatefulWidget {
//   /// Écran de gestion des mouvements de stock
//   /// Affiche l'historique des entrées/sorties avec filtres
//
//   @override
//   _MovementsScreenState createState() => _MovementsScreenState();
// }
//
// class _MovementsScreenState extends State<MovementsScreen> {
//   final _filterFormKey = GlobalKey<FormState>(); // Clé pour le formulaire de filtres
//   DateTime? _startDate; // Date de début pour le filtrage
//   DateTime? _endDate; // Date de fin pour le filtrage
//   String _movementType = 'all'; // Type de mouvement pour le filtrage
//   bool _showFilters = false; // Si les filtres sont visibles
//
//   @override
//   void initState() {
//     super.initState();
//     // Charge les mouvements au démarrage
//     Future.delayed(Duration.zero, () {
//       Provider.of<MovementProvider>(context, listen: false).fetchMovements();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final movementProvider = Provider.of<MovementProvider>(context);
//     final movements = movementProvider.movements;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Historique des Mouvements'),
//         backgroundColor: Colors.blue.shade700,
//         actions: [
//           // Bouton pour afficher/masquer les filtres
//           IconButton(
//             icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
//             onPressed: () => setState(() => _showFilters = !_showFilters),
//             tooltip: 'Filtres',
//           ),
//           // Bouton pour ajouter un mouvement
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddMovementDialog(context),
//             tooltip: 'Nouveau mouvement',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Section des filtres (affichée conditionnellement)
//           if (_showFilters) _buildFilters(),
//
//           // En-tête des statistiques
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.grey.shade50,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatItem(
//                   label: 'Total',
//                   value: movements.length.toString(),
//                   color: Colors.blue,
//                 ),
//                 _buildStatItem(
//                   label: 'Entrées',
//                   value: movements.where((m) => m.type == 'entry').length.toString(),
//                   color: Colors.green,
//                 ),
//                 _buildStatItem(
//                   label: 'Sorties',
//                   value: movements.where((m) => m.type == 'exit').length.toString(),
//                   color: Colors.orange,
//                 ),
//               ],
//             ),
//           ),
//
//           // Liste des mouvements
//           Expanded(
//             child: movements.isEmpty
//                 ? _buildEmptyState() // État vide si aucun mouvement
//                 : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               itemCount: movements.length,
//               itemBuilder: (context, index) {
//                 final movement = movements[index];
//                 return MovementItem(movement: movement);
//               },
//             ),
//           ),
//         ],
//       ),
//
//       // Bouton flottant pour ajouter un mouvement
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddMovementDialog(context),
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.orange,
//       ),
//     );
//   }
//
//   /// Construit la section des filtres
//   Widget _buildFilters() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Form(
//         key: _filterFormKey,
//         child: Column(
//           children: [
//             // Filtre par type de mouvement
//             DropdownButtonFormField(
//               value: _movementType,
//               items: const [
//                 DropdownMenuItem(value: 'all', child: Text('Tous les mouvements')),
//                 DropdownMenuItem(value: 'entry', child: Text('Entrées seulement')),
//                 DropdownMenuItem(value: 'exit', child: Text('Sorties seulement')),
//               ],
//               onChanged: (value) {
//                 setState(() => _movementType = value.toString());
//                 _applyFilters();
//               },
//               decoration: const InputDecoration(
//                 labelText: 'Type de mouvement',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Filtres par date
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => _selectDate(context, isStartDate: true),
//                     child: InputDecorator(
//                       decoration: const InputDecoration(
//                         labelText: 'Date de début',
//                         border: OutlineInputBorder(),
//                       ),
//                       child: Text(
//                         _startDate != null
//                             ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
//                             : 'Sélectionner',
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => _selectDate(context, isStartDate: false),
//                     child: InputDecorator(
//                       decoration: const InputDecoration(
//                         labelText: 'Date de fin',
//                         border: OutlineInputBorder(),
//                       ),
//                       child: Text(
//                         _endDate != null
//                             ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
//                             : 'Sélectionner',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Boutons d'action des filtres
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: _resetFilters,
//                     child: const Text('Réinitialiser'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _applyFilters,
//                     child: const Text('Appliquer'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Construit un élément de statistique
//   Widget _buildStatItem({required String label, required String value, required Color color}) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Construit l'état vide quand il n'y a pas de mouvements
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.compare_arrows,
//             size: 64,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Aucun mouvement enregistré',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Commencez par ajouter un mouvement',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Ouvre le sélecteur de date
//   Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = picked;
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }
//
//   /// Applique les filtres aux mouvements
//   void _applyFilters() {
//     final movementProvider = Provider.of<MovementProvider>(context, listen: false);
//     movementProvider.applyFilters(
//       startDate: _startDate,
//       endDate: _endDate,
//       type: _movementType == 'all' ? null : _movementType,
//     );
//   }
//
//   /// Réinitialise tous les filtres
//   void _resetFilters() {
//     setState(() {
//       _startDate = null;
//       _endDate = null;
//       _movementType = 'all';
//     });
//
//     final movementProvider = Provider.of<MovementProvider>(context, listen: false);
//     movementProvider.resetFilters();
//   }
//
//   /// Affiche le dialogue d'ajout de mouvement
//   void _showAddMovementDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Nouveau Mouvement'),
//         content: AddMovementForm(),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Annuler'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // TODO: Implémenter la sauvegarde du mouvement
//               Navigator.pop(context);
//             },
//             child: const Text('Enregistrer'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Formulaire d'ajout de mouvement (à compléter)
// class AddMovementForm extends StatefulWidget {
//   @override
//   _AddMovementFormState createState() => _AddMovementFormState();
// }
//
// class _AddMovementFormState extends State<AddMovementForm> {
//   // TODO: Implémenter le formulaire complet
//   @override
//   Widget build(BuildContext context) {
//     return const Text('Formulaire d\'ajout de mouvement');
//   }
// }
// screens/movements_screen.dart
import 'package:flutter/material.dart';
import 'package:nethastock/models/movement.dart';
import 'package:nethastock/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../providers/movement_provider.dart';
import '../widgets/movement_item.dart';
import '../widgets/filter_widget.dart';

class MovementsScreen extends StatefulWidget {
  @override
  _MovementsScreenState createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  final _filterFormKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String _movementType = 'all';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MovementProvider>(context, listen: false).fetchMovements();
  }

  @override
  Widget build(BuildContext context) {
    final movementProvider = Provider.of<MovementProvider>(context);
    final movements = movementProvider.movements;

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Mouvements'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilters(),
          Expanded(
            child: movements.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movements.length,
              itemBuilder: (context, index) => MovementItem(
                movement: movements[index],
                onTap: () => _showMovementDetails(context, movements[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return FilterWidget(
      formKey: _filterFormKey,
      startDate: _startDate,
      endDate: _endDate,
      movementType: _movementType,
      onStartDateChanged: (date) => setState(() => _startDate = date),
      onEndDateChanged: (date) => setState(() => _endDate = date),
      onTypeChanged: (type) => setState(() => _movementType = type),
      onApplyFilters: _applyFilters,
      onResetFilters: _resetFilters,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compare_arrows, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text('Aucun mouvement enregistré', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('Commencez par ajouter un mouvement', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  void _applyFilters() {
    Provider.of<MovementProvider>(context, listen: false).applyFilters(
      startDate: _startDate,
      endDate: _endDate,
      type: _movementType == 'all' ? null : _movementType,
    );
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _movementType = 'all';
    });
    Provider.of<MovementProvider>(context, listen: false).resetFilters();
  }

  void _showMovementDetails(BuildContext context, Movement movement) {
    showDialog(
      context: context,
      builder: (context) => MovementDetailsDialog(movement: movement),
    );
  }
}

class MovementDetailsDialog extends StatelessWidget {
  final Movement movement;

  const MovementDetailsDialog({required this.movement});

  @override
  Widget build(BuildContext context) {
    final isPending = movement.status == 'pending';
    final isAdmin = Provider.of<AuthProvider>(context).user?.role == 'administrateur';

    return AlertDialog(
      title: Text('Détails du Mouvement'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Produit: ${movement.productId}'),
          Text('Type: ${movement.type == 'entry' ? 'Entrée' : 'Sortie'}'),
          Text('Quantité: ${movement.quantity}'),
          Text('Statut: ${_getStatusText(movement.status)}'),
          if (movement.motif != null) Text('Motif: ${movement.motif}'),
          Text('Date: ${movement.date.toString()}'),
        ],
      ),
      actions: [
        if (isPending && isAdmin) ...[
          TextButton(
            onPressed: () => _validateMovement(context, true),
            child: Text('Valider', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => _validateMovement(context, false),
            child: Text('Rejeter', style: TextStyle(color: Colors.red)),
          ),
        ],
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fermer'),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'En attente';
      case 'validated': return 'Validé';
      case 'rejected': return 'Rejeté';
      default: return status;
    }
  }

  void _validateMovement(BuildContext context, bool approve) async {
    try {
      // Implémenter la validation via l'API
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