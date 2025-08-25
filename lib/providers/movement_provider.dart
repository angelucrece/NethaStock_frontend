// import 'package:flutter/foundation.dart';
// import '../models/movement.dart';
// import '../services/api_service.dart';
//
// class MovementProvider with ChangeNotifier {
//   List<Movement> _movements = [];
//   List<Movement> _filteredMovements = [];
//   bool _isLoading = false;
//   String? _error;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   String? _typeFilter;
//
//   List<Movement> get movements => _filteredMovements;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   MovementProvider() {
//     fetchMovements();
//   }
//
//   Future<void> fetchMovements() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().getMovements(
//         startDate: _startDate,
//         endDate: _endDate,
//         type: _typeFilter,
//       );
//
//       if (response.success) {
//         _movements = response.data ?? [];
//         _filteredMovements = _movements;
//         _error = null;
//       } else {
//         _error = response.message;
//       }
//     } catch (e) {
//       _error = 'Erreur de chargement des mouvements: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<bool> addMovement(Movement movement) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await ApiService().createMovement(movement);
//
//       if (response.success) {
//         _movements.insert(0, response.data!);
//         _filteredMovements = _movements;
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = response.message;
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Erreur d\'ajout du mouvement: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   void applyFilters({
//     DateTime? startDate,
//     DateTime? endDate,
//     String? type,
//   }) {
//     _startDate = startDate;
//     _endDate = endDate;
//     _typeFilter = type;
//     fetchMovements();
//   }
//
//   void resetFilters() {
//     _startDate = null;
//     _endDate = null;
//     _typeFilter = null;
//     fetchMovements();
//   }
//
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

// providers/movement_provider.dart
import 'package:flutter/foundation.dart';
import '../models/movement.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class MovementProvider with ChangeNotifier {
  List<Movement> _movements = [];
  List<Movement> _filteredMovements = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _typeFilter;

  List<Movement> get movements => _filteredMovements;
  List<Movement> get pendingMovements => _movements.where((m) => m.status == 'pending').toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  MovementProvider() {
    fetchMovements();
  }

  Future<void> fetchMovements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getMovements(
        startDate: _startDate,
        endDate: _endDate,
        type: _typeFilter,
      );

      if (response.success) {
        _movements = response.data ?? [];
        _filteredMovements = _movements;
        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Erreur de chargement des mouvements: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMovement(Movement movement) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().createMovement(movement);

      if (response.success && response.data != null) {
        _movements.insert(0, response.data!);
        _filteredMovements = _movements;

        // Vérifier si besoin de validation
        if (movement.type == 'exit' && movement.quantity > _getValidationThreshold()) {
          // Notifier l'admin pour validation
          await NotificationService().showApprovalNotification(
              'Utilisateur', // Remplacer par le nom réel
              'Produit ${movement.productId}',
              movement.quantity
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur d\'ajout du mouvement: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> validateMovement(int movementId, bool approve) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().validateMovement(movementId, approve);

      if (response.success) {
        // Mettre à jour le statut localement
        final index = _movements.indexWhere((m) => m.id == movementId);
        if (index != -1) {
          _movements[index] = _movements[index].copyWith(
              status: approve ? 'validated' : 'rejected'
          );
          _filteredMovements = _movements;
        }

        // Notifier l'utilisateur
        if (approve) {
          await NotificationService().showMovementApproved(
              'Produit ${_movements[index].productId}',
              _movements[index].quantity
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erreur de validation: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  int _getValidationThreshold() {
    // Seuil de validation configurable (ex: 10% du stock moyen)
    return 10; // À adapter selon les besoins
  }

  void applyFilters({DateTime? startDate, DateTime? endDate, String? type}) {
    _startDate = startDate;
    _endDate = endDate;
    _typeFilter = type;
    fetchMovements();
  }

  void resetFilters() {
    _startDate = null;
    _endDate = null;
    _typeFilter = null;
    fetchMovements();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}