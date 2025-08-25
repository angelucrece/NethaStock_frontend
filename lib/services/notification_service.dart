// services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showStockAlert(String productName, int currentStock, int threshold) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'stock_channel',
      'Alertes Stock',
      channelDescription: 'Notifications pour les alertes de stock',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Alerte Stock Bas',
      'Le produit $productName est en stock bas ($currentStock/$threshold)',
      details,
    );
  }

  Future<void> showApprovalNotification(String userName, String productName, int quantity) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'approval_channel',
      'Validations Requises',
      channelDescription: 'Notifications pour les validations de mouvements',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      'Validation Requise',
      '$userName a effectué une sortie de $quantity $productName',
      details,
    );
  }

  Future<void> showMovementApproved(String productName, int quantity) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'movement_channel',
      'Mouvements Validés',
      channelDescription: 'Notifications pour les mouvements validés',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      2,
      'Mouvement Validé',
      'Votre sortie de $quantity $productName a été approuvée',
      details,
    );
  }
}