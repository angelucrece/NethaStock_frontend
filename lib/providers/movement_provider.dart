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
import '../models/reports.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class NotificationItem {
  final String type; // "lowStock", "pending", "validated"
  final String message;
  final DateTime date;

  NotificationItem({
    required this.type,
    required this.message,
    required this.date,
  });
}
class MovementProvider with ChangeNotifier {
  List<Movement> _movements = [];
  List<Movement> _filteredMovements = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _typeFilter;

  // Rapport de mouvements
  // MovementReport? _movementReport;
  // MovementReport? get movementReport => _movementReport;

  // Getters pour accéder aux données
  List<Movement> get movements => _movements;
  List<Movement> get filteredMovements => _filteredMovements;
  List<Movement> get pendingMovements => _movements.where((m) => m.status == 'pending').toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  final List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  void _addNotification(String type, String message) {
    _notifications.insert(
      0,
      NotificationItem(type: type, message: message, date: DateTime.now()),
    );
    notifyListeners();
  }

  IO.Socket? _socket;

  void initSocket(String token, String role, int userId) {
    _socket = IO.io(
      "http://ton-backend:3000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setQuery({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      print("✅ Connecté au serveur WebSocket");
    });

    // 🔔 Stock bas
    _socket!.on("lowStockAlert", (data) {
      _addNotification("lowStock", "Stock bas pour ${data['product']}");
    });

    // 🔔 Mouvement en attente (Admin uniquement)
    if (role == "administrateur") {
      _socket!.on("pendingMovement", (data) {
        _addNotification("pending", "Mouvement en attente: ${data['product']}");
      });
    }

    // 🔔 Mouvement validé/rejeté
    _socket!.on("movementValidated", (data) {
      final isMine = data['createdBy'] == userId;
      if (role == "administrateur") {
        _addNotification("validated", "Mouvement ${data['status']} pour ${data['product']}");
      } else if (role == "magasinier" && isMine) {
        _addNotification("validated", "Votre demande ${data['status']} (${data['product']})");
      }
    });

    _socket!.onDisconnect((_) => print("❌ Déconnecté"));
  }

  /// Constructeur - chargement initial
  MovementProvider() {
    fetchMovements();
  }

  /// Charge tous les mouvements
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
        _applyLocalFilters();
        _error = null;
      } else {
        _error = response.message ?? 'Erreur inconnue lors du chargement';
      }
    } catch (e) {
      _error = 'Erreur de chargement des mouvements: ${e.toString()}';
      if (_movements.isEmpty) {
        _movements = [];
        _filteredMovements = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Applique les filtres locaux
  void _applyLocalFilters() {
    _filteredMovements = _movements.where((movement) {
      if (_typeFilter != null && _typeFilter != 'all') {
        if (movement.type != _typeFilter) return false;
      }

      if (_startDate != null) {
        if (movement.date.isBefore(_startDate!)) return false;
      }

      if (_endDate != null) {
        final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        if (movement.date.isAfter(endOfDay)) return false;
      }

      return true;
    }).toList();
  }

  /// Ajout d’un mouvement
  Future<bool> addMovement(Movement movement) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().createMovement(movement);

      if (response.success && response.data != null) {
        _movements.insert(0, response.data!);
        _applyLocalFilters();

        if (movement.type == 'exit' && movement.quantity > _getValidationThreshold()) {
          await NotificationService().showApprovalNotification(
            movement.userName ?? 'Utilisateur',
            movement.productName ?? 'Produit ${movement.productId}',
            movement.quantity,
          );
        }

        return true;
      } else {
        _error = response.message ?? 'Erreur lors de l\'ajout du mouvement';
        return false;
      }
    } catch (e) {
      _error = 'Erreur d\'ajout du mouvement: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validation/Rejet
  Future<bool> validateMovement(int movementId, bool approve) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().validateMovement(movementId, approve);

      if (response.success) {
        final index = _movements.indexWhere((m) => m.id == movementId);
        if (index != -1) {
          _movements[index] = _movements[index].copyWith(
            status: approve ? 'validated' : 'rejected',
          );
          _applyLocalFilters();

          if (approve) {
            await NotificationService().showMovementApproved(
              _movements[index].productName ?? 'Produit ${_movements[index].productId}',
              _movements[index].quantity,
            );
          }
        }
        return true;
      } else {
        _error = response.message ?? 'Erreur lors de la validation';
        return false;
      }
    } catch (e) {
      _error = 'Erreur de validation: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 👉 Récupère un rapport de mouvements
  Future<void> fetchMovementReport({String? type, String? startDate, String? endDate}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    //
    // try {
    //   _movementReport = await ApiService().getMovementReport(
    //     type: type,
    //     startDate: startDate,
    //     endDate: endDate,
    //   );
    // } catch (e) {
    //   _error = "Erreur récupération movement report: $e";
    // } finally {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  /// Application de filtres
  void applyFilters({DateTime? startDate, DateTime? endDate, String? type}) {
    _startDate = startDate;
    _endDate = endDate;
    _typeFilter = type;
    _applyLocalFilters();
    notifyListeners();
  }

  void resetFilters() {
    _startDate = null;
    _endDate = null;
    _typeFilter = null;
    _filteredMovements = _movements;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  int _getValidationThreshold() {
    return 10;
  }

  /// Stats rapides
  Map<String, int> getMovementStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisMonth = DateTime(now.year, now.month, 1);

    return {
      'total': _movements.length,
      'pending': _movements.where((m) => m.status == 'pending').length,
      'today': _movements.where((m) => m.date.isAfter(today)).length,
      'thisMonth': _movements.where((m) => m.date.isAfter(thisMonth)).length,
      'entries': _movements.where((m) => m.type == 'entry').length,
      'exits': _movements.where((m) => m.type == 'exit').length,
    };
  }

  /// Recherche
  void searchMovements(String query) {
    if (query.isEmpty) {
      _applyLocalFilters();
    } else {
      _filteredMovements = _movements.where((movement) {
        final productName = movement.productName?.toLowerCase() ?? '';
        final userName = movement.userName?.toLowerCase() ?? '';
        final motif = movement.motif?.toLowerCase() ?? '';

        return productName.contains(query.toLowerCase()) ||
            userName.contains(query.toLowerCase()) ||
            motif.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
