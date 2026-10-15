import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuritySharedpref {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _userTokenKey = 'user_token';

  /// Save token securely
  static Future<void> setToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
  }

  /// Get token securely
  Future<String?> getToken() async {
    return await _storage.read(key: _userTokenKey);
  }

  /// Set generic secured string
  static Future<void> setSecuredString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Get generic secured string
  static Future<String?> getSecuredString(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete specific key
  static Future<void> deleteSecuredData(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all secured data (e.g. on logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
