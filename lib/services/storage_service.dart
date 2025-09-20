import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final _secure = const FlutterSecureStorage();
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kTheme = 'theme_mode';

  Future<void> saveTokens(String access, String refresh) async {
    await _secure.write(key: _kAccess, value: access);
    await _secure.write(key: _kRefresh, value: refresh);
  }

  Future<Map<String, String?>> readTokens() async {
    final a = await _secure.read(key: _kAccess);
    final r = await _secure.read(key: _kRefresh);
    return {'access': a, 'refresh': r};
  }

  Future<void> clearTokens() async {
    await _secure.delete(key: _kAccess);
    await _secure.delete(key: _kRefresh);
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTheme, mode);
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTheme);
  }
}
