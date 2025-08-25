import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.tokenKey);
  }

  Future<void> setUserData(String userData) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.userKey, userData);
  }

  Future<String?> getUserData() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.userKey);
  }

  Future<void> clearUserData() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.userKey);
  }

  Future<void> setTheme(String theme) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.themeKey, theme);
  }

  Future<String?> getTheme() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.themeKey);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}