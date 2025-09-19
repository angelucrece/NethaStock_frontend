import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service spécialisé pour les données du tableau de bord
class DashboardService {
  static const String baseUrl = 'http://localhost:3000/api'; // URL de votre API

  // Méthode privée pour récupérer le token d'authentification
  static Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (error) {
      throw Exception('Erreur lors de la récupération du token: $error');
    }
  }

  /// Récupère les données complètes du tableau de bord
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final token = await _getAuthToken();

      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reports/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Gestion des différents codes de statut HTTP
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          return responseData['data']; // Retourne les données du dashboard
        } else {
          throw Exception(responseData['message'] ?? 'Erreur inconnue');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode == 403) {
        throw Exception('Accès refusé. Permissions insuffisantes.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint non trouvé.');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Erreur de connexion. Vérifiez votre internet.');
    } on FormatException {
      throw Exception('Format de réponse invalide.');
    } catch (error) {
      throw Exception('Erreur inattendue: $error');
    }
  }

  /// Récupère les statistiques rapides (version light)
  static Future<Map<String, dynamic>> getQuickStats() async {
    try {
      final token = await _getAuthToken();

      final response = await http.get(
        Uri.parse('$baseUrl/reports/dashboard/quick-stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'] ?? {};
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la récupération des stats: $error');
    }
  }

  /// Met à jour les données en temps réel (WebSocket ou polling)
  static Stream<Map<String, dynamic>> getDashboardStream() {
    // Implémentation pour les mises à jour en temps réel
    return Stream.periodic(Duration(seconds: 30), (_) => {}).asyncMap((_) async {
      return await getDashboardData();
    });
  }
}