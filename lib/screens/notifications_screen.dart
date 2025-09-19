

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movement.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';
import '../models/api_response.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Product> _lowStockAlerts = [];
  List<Movement> _pendingMovements = [];
  bool _isLoading = true;
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _setupSocket();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);

    try {
      // 1️⃣ Récupérer alertes stock bas
      final stockResponse = await ApiService().getLowStockAlerts();
      if (stockResponse.success) {
        _lowStockAlerts = stockResponse.data!
            .map((e) => Product.fromJson(e))
            .toList();
      }

      // 2️⃣ Récupérer mouvements en attente si admin
      //final role = Provider.of<UserProvider>(context, listen: false).currentUser?.role;
      final role = Provider.of<UserProvider>(context, listen: false).currentUser?.role ?? 'magasinier';

      if (role == 'administrateur') {
        final pendingResponse = await ApiService().getPendingMovements();
        if (pendingResponse.success) {
          _pendingMovements = pendingResponse.data!
              .map((e) => Movement.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur récupération notifications: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setupSocket() {
    _socketService = SocketService();
    SocketService.connect();

    // 🔔 Alertes stock bas temps réel
    _socketService.on('lowStockAlert', (data) {
      final alert = Product.fromJson(data);
      if (!_lowStockAlerts.any((p) => p.id == alert.id)) {
        setState(() => _lowStockAlerts.insert(0, alert));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Stock bas: ${alert.name} (${alert.quantity} restant)')),
      );
    });

    // 🔔 Mouvements en attente temps réel (pour admin)
    _socketService.on('pendingMovement', (data) {
      final movement = Movement.fromJson(data);
      if (!_pendingMovements.any((m) => m.id == movement.id)) {
        setState(() => _pendingMovements.insert(0, movement));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📩 Nouveau mouvement en attente: ${movement.productName}')),
      );
    });

    // 🔔 Mouvements validés ou rejetés (pour magasinier)
    _socketService.on('movementValidated', (data) {
      final movement = Movement.fromJson(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Mouvement ${movement.status}: ${movement.productName}')),
      );
    });
  }

  @override
  void dispose() {
    SocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          if (_lowStockAlerts.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('⚠️ Stocks bas', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ..._lowStockAlerts.map((p) => ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: Text(p.name),
              subtitle: Text('Quantité: ${p.quantity} / Seuil: ${p.threshold}'),
              trailing: Text(
                'Déficit: ${p.threshold - p.quantity}',
                style: const TextStyle(color: Colors.red),
              ),
            )),
          ],
          if (_pendingMovements.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('📩 Mouvements en attente', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ..._pendingMovements.map((m) => ListTile(
              leading: const Icon(Icons.hourglass_empty, color: Colors.orange),
              title: Text(m.productName),
              subtitle: Text('Quantité: ${m.quantity} - Demandeur: ${m.userName}'),
            )),
          ],
          if (_lowStockAlerts.isEmpty && _pendingMovements.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Aucune notification'),
            )),
        ],
      ),
    );
  }
}

extension on SocketService {
  void on(String s, Null Function(dynamic data) param1) {}
}
