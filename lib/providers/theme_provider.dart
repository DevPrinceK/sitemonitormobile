import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final StorageService _storage = StorageService();
  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    final saved = await _storage.getThemeMode();
    if (saved != null) {
      _themeMode = _fromString(saved);
      notifyListeners();
    }
  }

  void toggle() {
    if (_themeMode == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.setThemeMode(_themeMode.name);
    notifyListeners();
  }

  ThemeMode _fromString(String v) {
    return ThemeMode.values
        .firstWhere((e) => e.name == v, orElse: () => ThemeMode.system);
  }
}
