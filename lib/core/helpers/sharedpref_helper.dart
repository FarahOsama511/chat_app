import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefHelper {
  static SharedPreferences? _sharedPref;
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<SharedPreferences> get _instance async {
    _sharedPref ??= await SharedPreferences.getInstance();
    return _sharedPref!;
  }

  static Future<void> cacheInitialization() async {
    try {
      _sharedPref = await SharedPreferences.getInstance();
    } catch (e) {
      log('Sharedpref initialization error: $e');
    }
  }

  static Future<bool> setData(String key, String value) async {
    final prefs = await _instance;
    return await prefs.setString(key, value);
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _instance;
    await prefs.setBool(_isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _sharedPref?.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearAuthData() async {
    final prefs = await _instance;
    await prefs.remove(_isLoggedInKey);
  }

  static String? getData(String key) {
    return _sharedPref?.getString(key);
  }

  static Future<bool> deleteData({required String key}) async {
    final prefs = await _instance;
    return await prefs.remove(key);
  }

  static Future<bool> setBoolData(String key, bool value) async {
    final prefs = await _instance;
    return await prefs.setBool(key, value);
  }

  static bool? getBoolData(String key) {
    return _sharedPref?.getBool(key);
  }
}
