import 'dart:convert'; // Pour le encodage/décodage JSON
import 'package:http/http.dart' as http; // Pour les requêtes HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Pour le stockage local
import '../models/api_response.dart'; // Modèle de réponse API
import '../models/user.dart'; // Modèle utilisateur
import '../models/product.dart'; // Modèle produit
import '../models/category.dart'; // Modèle catégorie
import '../models/movement.dart'; // Modèle mouvement
import '../utils/constants.dart'; // Constantes de l'application

class ApiService {
  // Pattern Singleton: une seule instance de ApiService
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // Constructeur privé
  ApiService._internal();

  static const String baseUrl = AppConstants.apiBaseUrl; // URL de base de l'API
  String? _token; // Token d'authentification JWT

  // Getter pour récupérer le token (le charge depuis le storage si nécessaire)
  Future<String?> get token async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(AppConstants.tokenKey);
    }
    return _token;
  }

  // Getter pour les headers HTTP avec authentification
  Future<Map<String, String>> get headers async {
    final token = await this.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Méthode générique pour traiter les réponses HTTP
  Future<ApiResponse<T>> _handleResponse<T>(
      http.Response response,
      T Function(dynamic) fromJson, // Fonction de conversion JSON → Objet
      ) async {
    try {
      final jsonResponse = json.decode(response.body);
      return ApiResponse<T>.fromJson(jsonResponse, fromJson);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de traitement de la réponse: $e',
        statusCode: response.statusCode,
      );
    }
  }


  Future<dynamic> updateUser(User user) async {
    // Implémentez l'appel API pour mettre à jour l'utilisateur
  }

  Future<dynamic> getUsers() async {
    // Implémentez l'appel API pour récupérer les utilisateurs
  }

  Future<dynamic> createUser(User user, String password) async {
    // Implémentez l'appel API pour créer un utilisateur
  }

  Future<dynamic> deactivateUser(String userId) async {
    // Implémentez l'appel API pour désactiver un utilisateur
  }

  Future<dynamic> activateUser(String userId) async {
    // Implémentez l'appel API pour activer un utilisateur
  }

  // ============ AUTHENTIFICATION ============ //

  /// Connexion d'un utilisateur
  /// [email] : Email de l'utilisateur
  /// [password] : Mot de passe de l'utilisateur
  /// Retourne une ApiResponse<User> avec les données de l'utilisateur
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final apiResponse = await _handleResponse<User>(response, (json) => User.fromJson(json));

      if (apiResponse.success) {
        _token = apiResponse.data?.token;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, _token!);
        if (apiResponse.data != null) {
          await prefs.setString(AppConstants.userKey, json.encode(apiResponse.data!.toJson()));
        }
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de connexion: $e',
      );
    }
  }

  /// Déconnexion de l'utilisateur
  /// Supprime le token et les données utilisateur du stockage local
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    _token = null;
  }

  // ============ PRODUITS ============ //

  /// Récupère la liste des produits
  /// [categoryId] : ID optionnel pour filtrer par catégorie
  /// Retourne une ApiResponse<List<Product>>
  Future<ApiResponse<List<Product>>> getProducts({int? categoryId}) async {
    try {
      final url = categoryId != null
          ? '$baseUrl/products?categoryId=$categoryId'
          : '$baseUrl/products';

      final response = await http.get(
        Uri.parse(url),
        headers: await headers,
      );

      return _handleResponse<List<Product>>(
        response,
            (data) => (data as List).map((item) => Product.fromJson(item)).toList(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de récupération des produits: $e',
      );
    }
  }

  /// Crée un nouveau produit
  /// [product] : Produit à créer
  /// Retourne une ApiResponse<Product> avec le produit créé
  Future<ApiResponse<Product>> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: await headers,
        body: json.encode(product.toJson()),
      );

      return _handleResponse<Product>(response, (json) => Product.fromJson(json));
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de création du produit: $e',
      );
    }
  }

  /// Met à jour un produit existant
  /// [product] : Produit avec les nouvelles données
  /// Retourne une ApiResponse<Product> avec le produit mis à jour
  Future<ApiResponse<Product>> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: await headers,
        body: json.encode(product.toJson()),
      );

      return _handleResponse<Product>(response, (json) => Product.fromJson(json));
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de mise à jour du produit: $e',
      );
    }
  }

  /// Supprime un produit
  /// [productId] : ID du produit à supprimer
  /// Retourne une ApiResponse<void>
  Future<ApiResponse<void>> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$productId'),
        headers: await headers,
      );

      return _handleResponse<void>(response, (_) => null);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de suppression du produit: $e',
      );
    }
  }

  // ============ CATÉGORIES ============ //

  /// Récupère la liste des catégories
  /// Retourne une ApiResponse<List<Category>>
  Future<ApiResponse<List<Category>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: await headers,
      );

      return _handleResponse<List<Category>>(
        response,
            (data) => (data as List).map((item) => Category.fromJson(item)).toList(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de récupération des catégories: $e',
      );
    }
  }

  // ============ MOUVEMENTS ============ //

  /// Récupère la liste des mouvements avec filtres optionnels
  /// [startDate] : Date de début pour le filtrage
  /// [endDate] : Date de fin pour le filtrage
  /// [type] : Type de mouvement ('entry' ou 'exit')
  /// Retourne une ApiResponse<List<Movement>>
  Future<ApiResponse<List<Movement>>> getMovements({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    try {
      var url = '$baseUrl/movements?';
      if (startDate != null) url += 'startDate=${startDate.toIso8601String()}&';
      if (endDate != null) url += 'endDate=${endDate.toIso8601String()}&';
      if (type != null) url += 'type=$type&';

      final response = await http.get(
        Uri.parse(url),
        headers: await headers,
      );

      return _handleResponse<List<Movement>>(
        response,
            (data) => (data as List).map((item) => Movement.fromJson(item)).toList(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de récupération des mouvements: $e',
      );
    }
  }

  /// Crée un nouveau mouvement de stock
  /// [movement] : Mouvement à créer
  /// Retourne une ApiResponse<Movement> avec le mouvement créé
  Future<ApiResponse<Movement>> createMovement(Movement movement) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/movements'),
        headers: await headers,
        body: json.encode(movement.toJson()),
      );

      return _handleResponse<Movement>(response, (json) => Movement.fromJson(json));
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de création du mouvement: $e',
      );
    }
  }
  // Validation des mouvements
  Future<ApiResponse<Movement>> validateMovement(int movementId, bool approve) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/movements/$movementId/validate'),
        headers: await headers,
        body: json.encode({'approve': approve}),
      );

      return _handleResponse<Movement>(response, (json) => Movement.fromJson(json));
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de validation: $e',
      );
    }
  }

  // Récupération des mouvements en attente
  Future<ApiResponse<List<Movement>>> getPendingMovements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movements?status=pending'),
        headers: await headers,
      );

      return _handleResponse<List<Movement>>(
        response,
            (data) => (data as List).map((item) => Movement.fromJson(item)).toList(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de récupération des validations: $e',
      );
    }
  }

  // Génération de rapports
  Future<ApiResponse<Map<String, dynamic>>> generateReport({
    required String type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var url = '$baseUrl/reports/$type?';
      if (startDate != null) url += 'startDate=${startDate.toIso8601String()}&';
      if (endDate != null) url += 'endDate=${endDate.toIso8601String()}&';

      final response = await http.get(
        Uri.parse(url),
        headers: await headers,
      );

      return _handleResponse<Map<String, dynamic>>(response, (data) => data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de génération de rapport: $e',
      );
    }
  }

  // ============ UPLOAD D'IMAGES ============ //

  /// Upload une image vers le serveur
  /// [imageFile] : Fichier image à uploader
  /// Retourne l'URL de l'image uploadée
  Future<String?> uploadImage(List<int> imageBytes, String fileName) async {
    try {
      final uri = Uri.parse('$baseUrl/upload');
      var request = http.MultipartRequest('POST', uri);

      // Ajoute le header d'autorisation
      final token = await this.token;
      request.headers['Authorization'] = 'Bearer $token';

      // Ajoute le fichier image
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: fileName,
      ));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = utf8.decode(responseData);
      final jsonResponse = json.decode(result);

      return jsonResponse['imageUrl'];
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image: $e');
    }
  }

  // ============ RAPPORTS ============ //

  /// Génère un rapport de stock
  /// [format] : Format du rapport ('pdf', 'excel', 'csv')
  /// Retourne les données du rapport
  Future<ApiResponse<dynamic>> generateStockReport(String format) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reports/stock?format=$format'),
        headers: await headers,
      );

      return _handleResponse<dynamic>(response, (data) => data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erreur de génération du rapport: $e',
      );
    }
  }
}

extension on User? {
  String? get token => null;
}