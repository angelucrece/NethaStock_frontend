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
  /// Gère les informations d'authentification et les rôles

  final int id; // Identifiant unique de l'utilisateur
  final String email; // Email de connexion
  final String role; // Rôle: 'administrateur' ou 'magasinier'
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de l'utilisateur
  final String? phone; // Numéro de téléphone (optionnel)
  final DateTime createdAt; // Date de création du compte
  final DateTime? lastLogin; // Date de dernière connexion
  final bool isActive;

  var token; // Statut actif/inactif du compte

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.createdAt,
    this.lastLogin,
    required this.isActive,
  });

  /// Factory method pour créer un User à partir des données JSON de l'API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isActive: json['isActive'],
    );
  }

  /// Convertit l'objet User en format JSON pour l'envoi à l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Getter pour le nom complet de l'utilisateur
  String get fullName => '$firstName $lastName';

  /// Getter pour vérifier si l'utilisateur est administrateur
  bool get isAdmin => role == 'administrateur';

  /// Getter pour vérifier si l'utilisateur est magasinier
  bool get isMagasinier => role == 'magasinier';

  /// Méthode pour créer une copie de l'utilisateur avec des valeurs modifiées
  User copyWith({
    int? id,
    String? email,
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