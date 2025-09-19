import 'dart:convert'; // Pour encoder/décoder le JSON
import 'dart:io';
import 'package:http/http.dart' as http; // Pour faire les requêtes HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Pour stocker localement les données
import '../models/analytics_report.dart';
import '../models/api_response.dart'; // Modèle de réponse API
import '../models/low_stock_alert.dart';
import '../models/movement_report.dart';
import '../models/paginated_products.dart';
import '../models/product_detail.dart';
import '../models/reports.dart';
import '../models/user.dart'; // Modèle utilisateur
import '../models/product.dart'; // Modèle produit
import '../models/category.dart' hide Product; // Modèle catégorie
import '../models/movement.dart'; // Modèle mouvement
import '../utils/constants.dart'; // Constantes de l'application
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // pour le mime type
import '../models/user_stats.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ApiService {
  // ==================== Singleton ==================== //
  static final ApiService _instance = ApiService._internal(); // Instance unique
  factory ApiService() => _instance; // Factory pour renvoyer l'instance
  ApiService._internal(); // Constructeur interne

  static const String baseUrl = AppConstants.apiBaseUrl; // URL de base de l'API
  String? _token; // Token JWT en mémoire

  // ==================== Gestion du token ==================== //

  /// Récupère le token depuis la mémoire ou SharedPreferences
  Future<String?> get token async {
    if (_token == null) { // Si token non chargé
      final prefs = await SharedPreferences.getInstance(); // On récupère SharedPreferences
      _token = prefs.getString(AppConstants.tokenKey); // On lit le token stocké
    }
    return _token; // On retourne le token
  }

  /// Retourne les headers HTTP avec le token
  Future<Map<String, String>> get headers async {
    final t = await token; // On récupère le token actuel
    return {
      'Content-Type': 'application/json',
      'Authorization': t != null ? 'Bearer $t' : '', // Si token présent, on l'ajoute
    };
  }

  /// Rafraîchit le token via l'API
  Future<bool> refreshToken() async {
    try {
      final currentToken = await token;
      if (currentToken == null) return false; // Pas de token à rafraîchir

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'), // Endpoint refresh
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentToken',
        },
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        final newToken = jsonResponse['token'];

        // On stocke le nouveau token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, newToken);
        _token = newToken; // Mise à jour en mémoire

        return true; // Rafraîchissement OK
      } else {
        return false; // Token invalide ou utilisateur inactif
      }
    } catch (e) {
      return false; // Erreur réseau ou serveur
    }
  }

  /// Wrapper pour toutes les requêtes sensibles au token
  Future<ApiResponse<T>> _safeRequest<T>(
      Future<ApiResponse<T>> Function() request) async {
    await refreshToken(); // On tente de rafraîchir le token avant la requête
    final response = await request(); // On fait la requête réelle
    return response; // On renvoie le résultat
  }

  // Assurez-vous que _safeRequest est correctement typée
  // Future<ApiResponse<T>> _safeRequest<T>(Future<ApiResponse<T>> Function() request) async {
  //   try {
  //     final ApiResponse<T> result = await request();
  //     return result;
  //   } catch (e) {
  //     // ✅ Retourner une instance correctement typée
  //     return ApiResponse<T>(
  //       success: false,
  //       message: 'Erreur dans la requête: $e',
  //       data: null,
  //     );
  //   }
  // }


  // ====================== UTILISATEURS ====================== //

  /// Génère le rapport de stock
  Future<Map<String, dynamic>> generateStockReport({bool lowStockOnly = false}) async {
    try {
      final response = await Dio().get(
        '$baseUrl/reports/stock',
        queryParameters: {'format': 'json', 'lowStockOnly': lowStockOnly.toString()},
        options: Options(headers: await headers),
      );

      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Erreur chargement rapport stock: $e');
    }
  }

  /// Génère le rapport des mouvements
  Future<Map<String, dynamic>> generateMovementReport({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    try {
      final params = {
        'format': 'json',
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (type != null) 'type': type,
      };

      final response = await Dio().get(
        '$baseUrl/reports/movements',
        queryParameters: params,
        options: Options(headers: await headers),
      );

      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Erreur chargement rapport mouvements: $e');
    }
  }

  /// Génère le rapport analytique
  Future<Map<String, dynamic>> generateAnalyticsReport({int period = 30}) async {
    try {
      final response = await Dio().get(
        '$baseUrl/reports/analytics',
        queryParameters: {'period': period.toString()},
        options: Options(headers: await headers),
      );

      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Erreur chargement rapport analytique: $e');
    }
  }

  /// Téléchargement d'un CSV (stock ou movements)
  Future<String> downloadCSV(String endpoint, String fileName) async {
    try {
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final savePath = '${tempDir.path}/$fileName.csv';

      await dio.download(
        '$baseUrl/reports/$endpoint?format=csv',
        savePath,
        options: Options(headers: await headers, responseType: ResponseType.bytes),
      );

      return savePath;
    } catch (e) {
      throw Exception('Erreur téléchargement CSV: $e');
    }
  }
  /// ✅ Rapport Analytics
  Future<ApiResponse<AnalyticsReport>> getAnalyticsReport({int periodDays = 30}) async {
    try {
      final uri = Uri.parse('$baseUrl/reports/analytics?period=$periodDays');
      final response = await http.get(uri, headers: await headers);

      final Map<String, dynamic> data = json.decode(response.body);

      return ApiResponse<AnalyticsReport>(
        success: data['success'] ?? false,
        message: data['message'] ?? '',
        data: data['success'] == true
            ? AnalyticsReport.fromJson(data['data'])
            : null,
      );
    } catch (e) {
      return ApiResponse<AnalyticsReport>(
        success: false,
        message: 'Erreur: $e',
        data: null,
      );
    }
  }



  /// Récupère tous les utilisateurs (Admin)
  Future<ApiResponse<List<User>>> getUsers({String? search, String? role, int page = 1, int limit = 20}) async {
    return _safeRequest(() async {
      try {
        var url = '$baseUrl/users?page=$page&limit=$limit';
        if (search != null) url += '&search=$search';
        if (role != null) url += '&role=$role';

        final response = await http.get(Uri.parse(url), headers: await headers);

        return _handleResponse<List<User>>(
          response,
              (data) => (data as List).map((item) => User.fromJson(item)).toList(),
        );
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur de récupération des utilisateurs: $e');
      }
    });
  }

  /// Crée un nouvel utilisateur
  Future<ApiResponse<User>> createUser(User user, String password) async {
    return _safeRequest(() async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/register'), // Endpoint inscription
          headers: await headers,
          body: json.encode({
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'role': user.role,
            'password': password,
          }),
        );
        return _handleResponse<User>(response, (json) => User.fromJson(json));
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur création utilisateur: $e');
      }
    });
  }

  /// Met à jour un utilisateur existant
  Future<ApiResponse<User>> updateUser(User user) async {
    return _safeRequest(() async {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/users/${user.id}'),
          headers: await headers,
          body: json.encode({
            'firstName': user.firstName,
            'lastName': user.lastName,
            'role': user.role,
            'active': user.isActive,
          }),
        );
        return _handleResponse<User>(response, (json) => User.fromJson(json));
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur mise à jour utilisateur: $e');
      }
    });
  }

  /// Désactive un utilisateur (soft delete)
  Future<ApiResponse<void>> deactivateUser(int userId) async {
    return _safeRequest(() async {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/users/$userId'),
          headers: await headers,
        );
        return _handleResponse<void>(response, (_) => null);
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur désactivation utilisateur: $e');
      }
    });
  }

  /// Réactive un utilisateur
  Future<ApiResponse<void>> activateUser(int userId) async {
    return _safeRequest(() async {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/users/$userId/activate'),
          headers: await headers,
        );
        return _handleResponse<void>(response, (_) => null);
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur activation utilisateur: $e');
      }
    });
  }

  /// Récupère un utilisateur par ID
  Future<ApiResponse<User>> getUserById(int userId) async {
    return _safeRequest(() async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/users/$userId'),
          headers: await headers,
        );
        return _handleResponse<User>(response, (data) => User.fromJson(data));
      } catch (e) {
        return ApiResponse(success: false, message: "Erreur API: $e");
      }
    });
  }

    ///
  Future<ApiResponse<User>> changePassword(User user) async {
    return _safeRequest(() async {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/users/${user.id}'),
          headers: await headers,
          body: json.encode({
            'firstName': user.firstName,
            'lastName': user.lastName,
            'role': user.role,
            'active': user.isActive,
          }),
        );
        return _handleResponse<User>(response, (json) => User.fromJson(json));
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur mise à jour utilisateur: $e');
      }
    });
  }

  Future<Map<String, dynamic>> fetchUserStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/admin/stats'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Erreur serveur');
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }
  // ====================== AUTHENTIFICATION ====================== //

  /// Connexion
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email.trim(), 'password': password}),
      );

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200 && responseJson['success'] == true) {
        final userJson = responseJson['user'];
        final token = responseJson['token'];

        final user = User.fromJson(userJson, token: token);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, token);
        await prefs.setString(AppConstants.userKey, json.encode(userJson));
        _token = token;

        return ApiResponse<User>(
          success: true,
          message: responseJson['message'],
          data: user,
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: responseJson['message'] ?? 'Email ou mot de passe incorrect',
        );
      }
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Erreur de connexion: $e',
      );
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    _token = null;
  }

  // ====================== PRODUITS ====================== //

  // Future<ApiResponse<List<Product>>> getProducts({int? categoryId}) async {
  //   return _safeRequest(() async {
  //     try {
  //       final url = categoryId != null ? '$baseUrl/products?categoryId=$categoryId' : '$baseUrl/products';
  //       final response = await http.get(Uri.parse(url), headers: await headers);
  //
  //       return _handleResponse<List<Product>>(
  //         response,
  //             (data) => (data as List).map((item) => Product.fromJson(item)).toList(),
  //       );
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de récupération des produits: $e');
  //     }
  //   });
  // }
  // /// Récupère toute la liste de produits
  // Future<ApiResponse<List<Product>>> getProducts({String? search, int? categoryId, int page = 1, int limit = 20, bool lowStock = false}) async {
  //   return _safeRequest(() async {
  //     try {
  //       var url = '$baseUrl/products?page=$page&limit=$limit';
  //       if (search != null) url += '&search=$search';
  //       if (categoryId != null) url += '&role=$categoryId';
  //       if (lowStock != null) url += '&role=$lowStock';
  //
  //       final response = await http.get(Uri.parse(url), headers: await headers);
  //
  //       return _handleResponse<List<Product>>(
  //         response,
  //             (data) => (data as List).map((item) => Product.fromJson(item)).toList(),
  //       );
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de récupération des utilisateurs: $e');
  //     }
  //   });
  // }
  //
  //
  // ///creation d'un nouveau produit (Admin)
  // Future<ApiResponse<Product>> createProduct(Product product) async {
  //   return _safeRequest(() async {
  //     try {
  //       final response = await http.post(Uri.parse('$baseUrl/products'), headers: await headers, body: json.encode(product.toJson()));
  //       return _handleResponse<Product>(response, (json) => Product.fromJson(json));
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de création du produit: $e');
  //     }
  //   });
  // }
  //
  // ///Mise a jour d'un produit existant (Admin)
  // Future<ApiResponse<Product>> updateProduct(Product product) async {
  //   return _safeRequest(() async {
  //     try {
  //       final response = await http.put(Uri.parse('$baseUrl/products/${product.id}'), headers: await headers, body: json.encode(product.toJson()));
  //       return _handleResponse<Product>(response, (json) => Product.fromJson(json));
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de mise à jour du produit: $e');
  //     }
  //   });
  // }
  //
  // ///suppression d'un produit (Admin)
  // Future<ApiResponse<void>> deleteProduct(int productId) async {
  //   return _safeRequest(() async {
  //     try {
  //       final response = await http.delete(Uri.parse('$baseUrl/products/$productId'), headers: await headers);
  //       return _handleResponse<void>(response, (_) => null);
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de suppression du produit: $e');
  //     }
  //   });
  // }
  // /// Récupère les infos d'un produit
  // Future<ApiResponse<Product>> getProductById(int productId) async {
  //   return _safeRequest(() async {
  //     try {
  //       final response = await http.get(
  //         Uri.parse('$baseUrl/products/$productId'),
  //         headers: await headers,
  //       );
  //       return _handleResponse<Product>(response, (data) => Product.fromJson(data));
  //     } catch (e) {
  //       return ApiResponse(success: false, message: "Erreur API: $e");
  //     }
  //   });
  // }
  //
  // Récupère la liste paginée de produits avec filtres
  //
  // Future<List<Product>> fetchProducts({String search = ""}) async {
  //   final queryParameters = {
  //     "page": "1",
  //     "limit": "20",
  //   };
  //
  //   if (search.isNotEmpty) {
  //     queryParameters["search"] = search;
  //   }
  //
  //   final url = Uri.http("localhost:3000", "/api/products", queryParameters);
  //   print("➡️ Appel API: $url");
  //
  //   final response = await http.get(
  //     url,
  //     headers: await headers,
  //   );
  //
  //   print("⬅️ Réponse API: ${response.statusCode}");
  //   print(response.body);
  //
  //   if (response.statusCode == 200) {
  //     final body = json.decode(response.body);
  //     final List<dynamic> data = body['data'];
  //     return data.map((json) => Product.fromJson(json)).toList();
  //   } else {
  //     throw Exception("Erreur ${response.statusCode}");
  //   }
  // }

  Future<Product?> getProductByBarcode(String barcode, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/barcode/$barcode'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data['data']);
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchProducts({
    String search = '',
    int page = 1,
    int limit = 20,
    int? categoryId,
    bool lowStock = false,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (categoryId != null) 'categoryId': categoryId.toString(),
      'lowStock': lowStock.toString(),
    };

    if (search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final uri = Uri.parse('$baseUrl/products').replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: await headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = (data['data'] as List).map((e) => Product.fromJson(e)).toList();
      return {'products': products, 'pagination': data['pagination']};
    }

    throw Exception('Erreur récupération produits');
  }


  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'), headers: await headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Product.fromJson(data);
    }
    throw Exception('Produit non trouvé');
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'), headers: await headers);
    if (response.statusCode != 200) throw Exception('Erreur suppression produit');
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: await headers,
      body: json.encode(productData),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body)['data']);
    }
    throw Exception('Erreur création produit');
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: await headers,
      body: json.encode(productData),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body)['data']);
    }
    throw Exception('Erreur mise à jour produit');
  }

  Future<String> uploadImage(File imageFile) async {
    final uri = Uri.parse('$baseUrl/products/upload-image');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(await headers);

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // ⚠️ doit matcher avec req.files.image
        imageFile.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      return data['data']['imageUrl']; // ton backend renvoie dans data.imageUrl
    }

    throw Exception('Erreur upload image (${response.statusCode})');
  }

  Future<String> uploadWebImage(Uint8List bytes, {String fileName = 'upload.jpg'}) async {
    final uri = Uri.parse('$baseUrl/products/upload-image');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(await headers);

    request.files.add(
      http.MultipartFile.fromBytes(
        'image', // ⚠️ idem → backend attend "image"
        bytes,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      return data['data']['imageUrl'];
    }

    throw Exception('Erreur upload image (${response.statusCode})');
  }

  static Future<Product> fetchProductById(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer YOUR_TOKEN"},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Product.fromJson(body['data']);
    } else {
      throw Exception("Produit non trouvé");
    }
  }
  // Récupération des produits en stock faible
  Future<ApiResponse<List<dynamic>>> getLowStockAlerts() async {
    return _safeRequest(() async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/products/low-stock'),
          headers: await headers,
        );

        return _handleResponse<List<dynamic>>(response, (json) {
          // On retourne la liste brute envoyée par le backend
          if (json is List) {
            return json;
          } else if (json is Map && json["data"] != null) {
            return json["data"] as List<dynamic>;
          }
          return [];
        });
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur récupération stock bas: $e');
      }
    });
  }


  //  Future<void> createProduct(Product product) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/products'),
  //     headers: await headers,
  //     body: json.encode({
  //       "name": product.name,
  //       "barcode": product.barcode,
  //       "price": product.price,
  //       "quantity": product.quantity,
  //       "threshold": product.threshold,
  //       "categoryId": product.categoryId,
  //       "description": product.description,
  //       "purchasePrice": product.purchasePrice,
  //       "imageUrl": product.imageUrl,
  //     }),
  //   );
  //
  //   if (response.statusCode != 201) {
  //     throw Exception("Erreur lors de la création du produit");
  //   }
  // }
  //
  // Future<ApiResponse<PaginatedProducts>> getProducts({
  //   String search = '',
  //   int page = 1,
  //   int limit = 20,
  //   int? categoryId,
  //   bool lowStock = false,
  // }) async {
  //   return _safeRequest(() async {
  //     final queryParams = <String, String>{
  //       'page': page.toString(),
  //       'limit': limit.toString(),
  //     };
  //     if (search.isNotEmpty) queryParams['search'] = search;
  //     if (categoryId != null) queryParams['categoryId'] = categoryId.toString();
  //     if (lowStock) queryParams['lowStock'] = 'true';
  //
  //     final uri = Uri.parse('$baseUrl/products').replace(queryParameters: queryParams);
  //     final response = await http.get(uri, headers: await headers);
  //     return _handleResponse<PaginatedProducts>(
  //       response,
  //           (data) => PaginatedProducts.fromJson(data),
  //     );
  //   });
  // }

  // Future<ApiResponse<ProductDetail>> getProductDetail(int productId) async {
  //   return _safeRequest(() async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/products/$productId'),
  //       headers: await headers,
  //     );
  //     return _handleResponse<ProductDetail>(
  //       response,
  //           (data) => ProductDetail.fromJson(data),
  //     );
  //   });
  // }

  // Future<ApiResponse<Product>> createProduct(Product product) async {
  //   return _safeRequest(() async {
  //     final productData = {
  //       'name': product.name,
  //       'barcode': product.barcode,
  //       'description': product.description,
  //       'categoryId': product.categoryId,
  //       'purchasePrice': product.purchasePrice,
  //       'price': product.price,
  //       'quantity': product.quantity,
  //       'threshold': product.threshold,
  //       'imageUrl': product.imageUrl,
  //     };
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/products'),
  //       headers: await headers,
  //       body: json.encode(productData),
  //     );
  //     return _handleResponse<Product>(
  //       response,
  //           (data) => Product.fromJson(data),
  //     );
  //   });
  // }

  // Future<ApiResponse<Product>> updateProduct(Product product) async {
  //   return _safeRequest(() async {
  //     final productData = {
  //       'name': product.name,
  //       'barcode': product.barcode,
  //       'description': product.description,
  //       'categoryId': product.categoryId,
  //       'purchasePrice': product.purchasePrice,
  //       'price': product.price,
  //       'quantity': product.quantity,
  //       'threshold': product.threshold,
  //       'imageUrl': product.imageUrl,
  //     };
  //     final response = await http.put(
  //       Uri.parse('$baseUrl/products/${product.id}'),
  //       headers: await headers,
  //       body: json.encode(productData),
  //     );
  //     return _handleResponse<Product>(
  //       response,
  //           (data) => Product.fromJson(data),
  //     );
  //   });
  // }
  //
  // Future<ApiResponse<void>> deleteProduct(int productId) async {
  //   return _safeRequest(() async {
  //     final response = await http.delete(
  //       Uri.parse('$baseUrl/products/$productId'),
  //       headers: await headers,
  //     );
  //     return _handleResponse<void>(response, (_) => null);
  //   });
  // }
  //
  // Future<ApiResponse<Product>> getProductById(int productId) async {
  //   return _safeRequest(() async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/products/$productId'),
  //       headers: await headers,
  //     );
  //     return _handleResponse<Product>(
  //       response,
  //           (data) => Product.fromJson(data),
  //     );
  //   });
  // }
  //
  // Future<ApiResponse<Product>> getProductByBarcode(String barcode) async {
  //   return _safeRequest(() async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/products/barcode/${Uri.encodeComponent(barcode)}'),
  //       headers: await headers,
  //     );
  //     return _handleResponse<Product>(
  //       response,
  //           (data) => Product.fromJson(data),
  //     );
  //   });
  // }
  //
  // Future<ApiResponse<List<LowStockAlert>>> getLowStockProducts() async {
  //   return _safeRequest(() async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/products/alerts/low-stock'),
  //       headers: await headers,
  //     );
  //     return _handleResponse<List<LowStockAlert>>(
  //       response,
  //           (data) => (data as List).map((item) => LowStockAlert.fromJson(item)).toList(),
  //     );
  //   });
  // }
  //
  // Future<ApiResponse<ImageUploadResponse>> uploadProductImage(File imageFile) async {
  //   return _safeRequest(() async {
  //     var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/products/upload-image'));
  //     final tokenHeaders = await headers;
  //     request.headers.addAll({'Authorization': tokenHeaders['Authorization'] ?? ''});
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'image',
  //       imageFile.path,
  //       filename: 'product_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //     ));
  //
  //     final response = await request.send();
  //     final responseData = await response.stream.bytesToString();
  //     final jsonResponse = json.decode(responseData);
  //
  //     if (response.statusCode == 200) {
  //       return ApiResponse<ImageUploadResponse>(
  //         success: true,
  //         message: 'Image uploadée avec succès',
  //         data: ImageUploadResponse.fromJson(jsonResponse),
  //       );
  //     } else {
  //       return ApiResponse<ImageUploadResponse>(
  //         success: false,
  //         message: jsonResponse['message'] ?? 'Erreur lors de l\'upload de l\'image',
  //       );
  //     }
  //   });
  // }

  // ====================== CATÉGORIES ====================== //
  /// Affiche la liste de toutes les catégories de produits
  Future<ApiResponse<List<Category>>> getCategories() async {
    return _safeRequest(() async {
      final response = await http.get(Uri.parse('$baseUrl/categories'), headers: await headers);
      return _handleResponse<List<Category>>(
        response,
            (data) => (data as List).map((item) => Category.fromJson(item)).toList(),
      );
    });
  }

  Future<ApiResponse<Category>> getCategoryById(int id) async {
    return _safeRequest(() async {
      final response = await http.get(Uri.parse('$baseUrl/categories/$id'), headers: await headers);
      return _handleResponse<Category>(response, (data) => Category.fromJson(data));
    });
  }


  /// Crée une nouvelle catégorie de produits
  Future<ApiResponse<Category>> createCategory(Category category, String name) async {
    return _safeRequest(() async {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: await headers,
        body: json.encode({
          'name': category.name,
          'description': category.description,
        }),
      );

      return _handleResponse<Category>(
        response,
            (data) => Category.fromJson(data),
      );
    });
  }

  /// Récupère les informations d’une catégorie par son ID


  /// Modifie une catégorie existante
  Future<ApiResponse<Category>> updateCategory(Category category) async {
    return _safeRequest(() async {
      final response = await http.put(
        Uri.parse('$baseUrl/categories/${category.id}'),
        headers: await headers,
        body: json.encode({
          'name': category.name,
          'description': category.description,
        }),
      );

      return _handleResponse<Category>(
        response,
            (data) => Category.fromJson(data),
      );
    });
  }

  /// Supprime une catégorie (hard delete)
  Future<ApiResponse<void>> deleteCategory(int categoryId) async {
    return _safeRequest(() async {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$categoryId'),
        headers: await headers,
      );

      return _handleResponse<void>(
        response,
            (_) => null, // pas de data dans la réponse
      );
    });
  }

  /// --- Helpers ---


  // ====================== MOUVEMENTS ====================== //

  /// Historique des mouvements avec pagination et filtres
  // Future<ApiResponse<List<Movement>>> getMovements({DateTime? startDate, DateTime? endDate, String? type}) async {
  //   return _safeRequest(() async {
  //     try {
  //       var url = '$baseUrl/movements?';
  //       if (startDate != null) url += 'startDate=${startDate.toIso8601String()}&';
  //       if (endDate != null) url += 'endDate=${endDate.toIso8601String()}&';
  //       if (type != null) url += 'type=$type&';
  //
  //       final response = await http.get(Uri.parse(url), headers: await headers);
  //       return _handleResponse<List<Movement>>(response, (data) => (data as List).map((item) => Movement.fromJson(item)).toList());
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de récupération des mouvements: $e');
  //     }
  //   });
  // }

  Future<ApiResponse<List<Movement>>> getMovements({DateTime? startDate, DateTime? endDate, String? type}) async {
    try {
      final params = {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (type != null) 'type': type,
      };

      final response = await http.get(
        Uri.parse('$baseUrl/movements').replace(queryParameters: params),
        headers: await headers,
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      // ✅ Conversion manuelle sans utiliser _handleResponse
      return ApiResponse<List<Movement>>.fromJson(
        {
          'success': responseData['success'] ?? false,
          'message': responseData['message'] ?? '',
          'data': responseData['data'],
          'statusCode': response.statusCode,
        },
            (data) {
          if (data is List) {
            return data.map((item) => Movement.fromJson(item)).toList();
          } else if (data is Map<String, dynamic>) {
            // Extraction depuis la Map
            for (var key in ['movements', 'items', 'content', 'data']) {
              if (data.containsKey(key) && data[key] is List) {
                return (data[key] as List).map((item) => Movement.fromJson(item)).toList();
              }
            }
            throw Exception('Aucune liste trouvée dans la Map');
          } else {
            throw Exception('Format invalide: ${data.runtimeType}');
          }
        },
      );
    } catch (e) {
      return ApiResponse<List<Movement>>(
        success: false,
        message: 'Erreur: $e',
        data: [],
      );
    }
  }
  ///creation d'un mouvement entree/sortie
  Future<ApiResponse<Movement>> createMovement(Movement movement) async {
    return _safeRequest(() async {
      try {
        final response = await http.post(Uri.parse('$baseUrl/movements'), headers: await headers, body: json.encode(movement.toJson()));
        return _handleResponse<Movement>(response, (json) => Movement.fromJson(json));
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur de création du mouvement: $e');
      }
    });
  }

  ///validation d'un mouvement
  Future<ApiResponse<Movement>> validateMovement(int movementId, bool approve) async {
    return _safeRequest(() async {
      try {
        final response = await http.put(Uri.parse('$baseUrl/movements/$movementId/validate'), headers: await headers, body: json.encode({'approve': approve}));
        return _handleResponse<Movement>(response, (json) => Movement.fromJson(json));
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur de validation: $e');
      }
    });
  }

    ///mouvement en attente de validation
  Future<ApiResponse<List<Movement>>> getPendingMovements() async {
    return _safeRequest(() async {
      try {
        final response = await http.get(Uri.parse('$baseUrl/movements?status=pending'), headers: await headers);
        return _handleResponse<List<Movement>>(response, (data) => (data as List).map((item) => Movement.fromJson(item)).toList());
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur de récupération des validations: $e');
      }
    });
  }

  Future<ApiResponse<Map<String, dynamic>>> generateReport({required String type, DateTime? startDate, DateTime? endDate}) async {
    return _safeRequest(() async {
      try {
        var url = '$baseUrl/reports/$type?';
        if (startDate != null) url += 'startDate=${startDate.toIso8601String()}&';
        if (endDate != null) url += 'endDate=${endDate.toIso8601String()}&';

        final response = await http.get(Uri.parse(url), headers: await headers);
        return _handleResponse<Map<String, dynamic>>(response, (data) => data);
      } catch (e) {
        return ApiResponse(success: false, message: 'Erreur de génération de rapport: $e');
      }
    });
  }



  // ====================== UPLOAD D'IMAGES ====================== //

  // Future<String?> uploadImage(List<int> imageBytes, String fileName) async {
  //   try {
  //     final uri = Uri.parse('$baseUrl/upload');
  //     var request = http.MultipartRequest('POST', uri);
  //
  //     final token = await this.token;
  //     request.headers['Authorization'] = 'Bearer $token';
  //     request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: fileName));
  //
  //     final response = await request.send();
  //     final responseData = await response.stream.toBytes();
  //     final result = utf8.decode(responseData);
  //     final jsonResponse = json.decode(result);
  //
  //     return jsonResponse['imageUrl'];
  //   } catch (e) {
  //     throw Exception('Erreur lors de l\'upload de l\'image: $e');
  //   }
  // }

  // ====================== RAPPORTS ====================== //

  // Future<ApiResponse<dynamic>> generateStockReport(String format) async {
  //   return _safeRequest(() async {
  //     try {
  //       final response = await http.get(Uri.parse('$baseUrl/reports/stock?format=$format'), headers: await headers);
  //       return _handleResponse<dynamic>(response, (data) => data);
  //     } catch (e) {
  //       return ApiResponse(success: false, message: 'Erreur de génération du rapport: $e');
  //     }
  //   });
  // }


  // ==================== Méthode privée pour gérer les réponses ==================== //

  // Future<ApiResponse<T>> _handleResponse<T>(http.Response response, T Function(dynamic) fromJson) async {
  //   try {
  //     final jsonResponse = json.decode(response.body);
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       final data = jsonResponse['data'];
  //       final result = data != null ? fromJson(data) : null;
  //       return ApiResponse<T>(
  //         success: jsonResponse['success'] ?? true,
  //         message: jsonResponse['message'] ?? '',
  //         data: result,
  //         statusCode: response.statusCode,
  //       );
  //     } else {
  //       return ApiResponse<T>(
  //         success: false,
  //         message: jsonResponse['message'] ?? 'Erreur serveur',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } catch (e) {
  //     return ApiResponse(
  //       success: false,
  //       message: 'Erreur de traitement de la réponse: $e',
  //       statusCode: response.statusCode,
  //     );
  //   }
  // }

  // Dans votre ApiService
  // ApiResponse<T> _handleResponse<T>(http.Response response, T Function(dynamic) converter) {
  //   try {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //
  //     // ✅ Utilisation correcte du factory fromJson
  //     return ApiResponse<T>.fromJson(
  //       {
  //         'success': responseData['success'] ?? false,
  //         'message': responseData['message'] ?? '',
  //         'data': responseData['data'], // Laisser la conversion à fromJsonT
  //         'statusCode': response.statusCode,
  //       },
  //       converter, // La fonction de conversion passe à fromJsonT
  //     );
  //   } catch (e) {
  //     // ✅ Retourner une ApiResponse correctement typée en cas d'erreur
  //     return ApiResponse<T>(
  //       success: false,
  //       message: 'Erreur de parsing: $e',
  //       statusCode: response.statusCode,
  //     );
  //   }
  // }
  ApiResponse<T> _handleResponse<T>(
      http.Response response,
      T Function(dynamic) converter,
      ) {
    try {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final dynamic rawData = responseData['data'] ?? responseData['user'] ?? responseData;

      return ApiResponse<T>.fromJson(
        {
          'success': responseData['success'] ?? false,
          'message': responseData['message'] ?? '',
          'data': rawData, // conversion déléguée
          'statusCode': response.statusCode,
        },
        converter,
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Erreur parsing JSON: $e',
        statusCode: response.statusCode,
      );
    }
  }


  // Future<ApiResponse<Map<String, dynamic>>> getDashboardData() async {
  //   return _safeRequest(() async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/reports/dashboard'), // Pas de point-virgule ici
  //       headers: await headers, // Assurez-vous d'inclure les headers
  //     );
  //
  //     // Utilisation de votre fonction _handleResponse pour traiter la réponse
  //     // On s'attend à ce que _handleResponse gère le statusCode 200 et extrait 'data'
  //     return _handleResponse<Map<String, dynamic>>(
  //       response,
  //           (data) => data as Map<String, dynamic>, // Le tableau de bord renvoie un objet JSON complet
  //     );
  //   });
  // }

  // Dans ApiService
  Future<ApiResponse> getDashboardData() async {
    return _safeRequest(() async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/reports/dashboard'),
          headers: await headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return ApiResponse(
            success: true,
            data: data['data'], message: '',
          );
        } else {
          return ApiResponse(
            success: false,
            message: 'Erreur serveur: ${response.statusCode}',
          );
        }
      } catch (error) {
        return ApiResponse(
          success: false,
          message: 'Erreur réseau: $error',
        );
      }
    });
  }


}



