// import 'package:flutter/cupertino.dart';
//
// class Movement {
//   final int id;
//   final int productId;
//   final String type;
//   final int quantity;
//   final int? userId;
//   final DateTime date;
//   final String status;
//   final Text? motif;
//   final DateTime createdAt;
//
//   Movement({
//     required this.id,
//     required this.productId,
//     required this.type,
//     required this.quantity,
//     this.userId,
//     required this.date,
//     required this.status,
//     this.motif,
//     required this.createdAt,
//   });
//   Movement copyWith({
//     int? id,
//     int? productId,
//     String? type,
//     int? quantity,
//     int? userId,
//     DateTime? date,
//     String? status,
//     Text? motif,
//     DateTime? createdAt,
//   }) {
//     return Movement(
//       id: id ?? this.id,
//       productId: productId ?? this.productId,
//       type: type ?? this.type,
//       quantity: quantity ?? this.quantity,
//       userId: userId ?? this.userId,
//       date: date ?? this.date,
//       status: status ?? this.status,
//       motif: motif ?? this.motif,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
//   factory Movement.fromJson(Map<String, dynamic> json) {
//     return Movement(
//       id: json['id'],
//       productId: json['productId'],
//       type: json['type'],
//       quantity: json['quantity'],
//       userId: json['userId'],
//       date: DateTime.parse(json['date']),
//       status: json['status'],
//       motif: json['motif'],
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'productId': productId,
//       'type': type,
//       'quantity': quantity,
//       'userId': userId,
//       'date': date.toIso8601String(),
//       'status': status,
//       'motif': motif,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
//
//   bool get isEntry => type == 'entry';
//   bool get isPending => status == 'pending';
// }



import 'package:flutter/cupertino.dart';

class Movement {
  final int? id; // Peut être null pour les nouveaux mouvements non sauvegardés
  final int productId;
  final String productName; // Ajout du nom du produit pour l'affichage
  final String type; // 'entry' ou 'exit'
  final int quantity;
  final int? userId;
  final String? userName; // Ajout du nom de l'utilisateur pour l'affichage
  final DateTime date;
  final String status; // 'pending', 'validated', 'rejected'
  final String? motif; // Changé de Text à String pour la sérialisation
  final DateTime createdAt;
  final DateTime? updatedAt;

  Movement({
    this.id,
    required this.productId,
    this.productName = '',
    required this.type,
    required this.quantity,
    this.userId,
    this.userName,
    required this.date,
    required this.status,
    this.motif,
    required this.createdAt,
    this.updatedAt,
  });

  /// Crée une copie du mouvement avec des valeurs optionnellement modifiées
  Movement copyWith({
    int? id,
    int? productId,
    String? productName,
    String? type,
    int? quantity,
    int? userId,
    String? userName,
    DateTime? date,
    String? status,
    String? motif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Movement(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      status: status ?? this.status,
      motif: motif ?? this.motif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Factory pour créer un Movement à partir de JSON
  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'] as int?,
      productId: json['product_id'] as int? ?? json['productId'] as int? ?? 0,
      productName: json['product_name'] as String? ??
          json['productName'] as String? ??
          json['product']?['name'] as String? ?? '',
      type: (json['type'] as String? ?? '').toLowerCase(),
      quantity: json['quantity'] as int? ?? 0,
      userId: json['user_id'] as int? ?? json['userId'] as int?,
      userName: json['user_name'] as String? ??
          json['userName'] as String? ??
          json['user']?['name'] as String? ??
          '${json['user']?['first_name'] ?? ''} ${json['user']?['last_name'] ?? ''}'.trim(),
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      status: (json['status'] as String? ?? 'pending').toLowerCase(),
      motif: json['motif'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convertit le Movement en JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     if (id != null) 'id': id,
  //     'product_id': productId,
  //     'type': type,
  //     'quantity': quantity,
  //     if (userId != null) 'user_id': userId,
  //     'date': date.toIso8601String(),
  //     'status': status,
  //     if (motif != null && motif!.isNotEmpty) 'motif': motif,
  //     'created_at': createdAt.toIso8601String(),
  //     if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
  //   };
  // }
  Map<String, dynamic> toJson() {
    return {
      'productId': productId, // <--- doit être un entier
      'type': type,
      'quantity': quantity,
      'motif': motif,
    };
  }

  /// Factory pour créer un Movement à partir d'une Map (compatibilité)
  factory Movement.fromMap(Map<String, dynamic> map) {
    return Movement.fromJson(map);
  }

  /// Convertit le Movement en Map (compatibilité)
  Map<String, dynamic> toMap() {
    return toJson();
  }

  /// Vérifie si le mouvement est une entrée de stock
  bool get isEntry => type == 'entry';

  /// Vérifie si le mouvement est une sortie de stock
  bool get isExit => type == 'exit';

  /// Vérifie si le mouvement est en attente de validation
  bool get isPending => status == 'pending';

  /// Vérifie si le mouvement est validé
  bool get isValidated => status == 'validated';

  /// Vérifie si le mouvement est rejeté
  bool get isRejected => status == 'rejected';

  /// Vérifie si le mouvement nécessite une validation (sortie importante)
  bool get requiresValidation => isExit && quantity > 10; // Seuil configurable

  /// Retourne l'icône appropriée selon le type de mouvement
  IconData get icon {
    if (isEntry) return CupertinoIcons.arrow_down_circle_fill;
    if (isExit) return CupertinoIcons.arrow_up_circle_fill;
    return CupertinoIcons.arrow_right_circle_fill;
  }

  /// Retourne la couleur appropriée selon le type de mouvement
  Color get color {
    if (isEntry) return const Color(0xFF4CAF50); // Vert
    if (isExit) return const Color(0xFFF44336); // Rouge
    return const Color(0xFF9E9E9E); // Gris
  }

  /// Retourne la couleur appropriée selon le statut
  Color get statusColor {
    if (isValidated) return const Color(0xFF4CAF50); // Vert
    if (isRejected) return const Color(0xFFF44336); // Rouge
    return const Color(0xFFFF9800); // Orange pour pending
  }

  /// Formate la date pour l'affichage
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Formate l'heure pour l'affichage
  String get formattedTime {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Retourne le texte du statut formaté
  String get statusText {
    switch (status) {
      case 'pending': return 'En attente';
      case 'validated': return 'Validé';
      case 'rejected': return 'Rejeté';
      default: return status;
    }
  }

  /// Retourne le texte du type formaté
  String get typeText {
    switch (type) {
      case 'entry': return 'Entrée';
      case 'exit': return 'Sortie';
      default: return type;
    }
  }

  /// Vérifie l'égalité entre deux mouvements
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movement &&
        other.id == id &&
        other.productId == productId &&
        other.type == type &&
        other.quantity == quantity &&
        other.date == date &&
        other.status == status;
  }

  /// Hash code pour l'égalité
  @override
  int get hashCode {
    return Object.hash(id, productId, type, quantity, date, status);
  }

  /// Représentation en string pour le debug
  @override
  String toString() {
    return 'Movement(id: $id, productId: $productId, type: $type, quantity: $quantity, status: $status, date: $date)';
  }

  /// Méthode utilitaire pour créer un mouvement d'entrée
  factory Movement.entry({
    int? id,
    required int productId,
    String productName = '',
    required int quantity,
    int? userId,
    String? userName,
    String? motif,
    DateTime? date,
  }) {
    return Movement(
      id: id,
      productId: productId,
      productName: productName,
      type: 'entry',
      quantity: quantity,
      userId: userId,
      userName: userName,
      date: date ?? DateTime.now(),
      status: 'validated', // Les entrées sont généralement auto-validées
      motif: motif,
      createdAt: DateTime.now(),
    );
  }

  /// Méthode utilitaire pour créer un mouvement de sortie
  factory Movement.exit({
    int? id,
    required int productId,
    String productName = '',
    required int quantity,
    int? userId,
    String? userName,
    String? motif,
    DateTime? date,
    bool requiresValidation = false,
  }) {
    return Movement(
      id: id,
      productId: productId,
      productName: productName,
      type: 'exit',
      quantity: quantity,
      userId: userId,
      userName: userName,
      date: date ?? DateTime.now(),
      status: requiresValidation ? 'pending' : 'validated',
      motif: motif,
      createdAt: DateTime.now(),
    );
  }

  /// Vérifie si le mouvement est valide
  bool isValid() {
    return productId > 0 &&
        quantity > 0 &&
        (type == 'entry' || type == 'exit') &&
        (status == 'pending' || status == 'validated' || status == 'rejected');
  }

  /// Retourne une description du mouvement pour les notifications
  String get description {
    return '${typeText} de $quantity unités${productName.isNotEmpty ? ' de $productName' : ''}';
  }
}