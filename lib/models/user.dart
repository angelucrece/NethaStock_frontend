// class User {
//   final int id;
//   final String email;
//   final String role;
//   final String? fullName;
//   final DateTime createdAt;
//
//   User({
//     required this.id,
//     required this.email,
//     required this.role,
//     this.fullName,
//     required this.createdAt,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       email: json['email'],
//       role: json['role'],
//       fullName: json['fullName'],
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'role': role,
//       'fullName': fullName,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
// }

class User {
  /// Modèle représentant un utilisateur du système NethaStock
  final int id;
  final String email;
  final String password; // mot de passe non renvoyé par le backend
  final String firstName;
  final String lastName;
  final String role; // 'administrateur' ou 'magasinier'
  final bool isActive;
  final String? phone; // optionnel
  final DateTime createdAt;
  final DateTime? lastLogin;
  final List<dynamic>? recentMovements; // mouvements récents de l'utilisateur
  final Map<String, dynamic>? stats; // 👈 Nouveau champ pour les stats
  String? token;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.createdAt,
    this.lastLogin,
    required this.isActive,
    this.recentMovements, // ajouter ici
    this.stats,

  });

  /// Factory sécurisée pour créer un User à partir du JSON
  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['id'] ?? 0,
      email: (json['email'] ?? '').toString(),
      password: '', // mot de passe non renvoyé par le backend
      role: (json['role'] ?? 'magasinier').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      phone: json['phone']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      isActive: json['active'] ?? true,
      recentMovements: (json['recentMovements'] as List<dynamic>?) ?? [],
      stats: json['stats'], // 👈 Récupération des stats
    )..token = token;
  }

  /// Convertit l'objet User en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'active': isActive,
      'recentMovements': recentMovements,
      'stats': stats, // 👈 Ajout au JSON
    };
  }

  String get fullName => '$firstName $lastName';

  bool get isAdmin => role == 'administrateur';
  bool get isMagasinier => role == 'magasinier';

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? role,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}

