import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  late final ApiService
      _apiService; // initialized after construction with setApi
  late final AuthService _authService;

  String? _accessToken;
  String? _refreshToken;
  User? _user;
  bool _loading = false;
  bool _initializing = true;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  User? get user => _user;
  bool get isAuthenticated => _accessToken != null;
  bool get loading => _loading;
  bool get initializing => _initializing;

  void attachApi(ApiService api) {
    _apiService = api;
    _authService = AuthService(_apiService);
  }

  Future<void> init() async {
    final tokens = await _storage.readTokens();
    _accessToken = tokens['access'];
    _refreshToken = tokens['refresh'];
    if (_accessToken != null) {
      try {
        _user = await _authService.currentUser();
      } catch (_) {
        // token might be invalid
      }
    }
    _initializing = false;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final tokens = await _authService.login(username, password);
      await setTokens(tokens['access']!, tokens['refresh']!);
      _user = await _authService.currentUser();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String password) async {
    await _authService.register(username, password);
    await login(username, password);
  }

  Future<void> setTokens(String access, String refresh) async {
    _accessToken = access;
    _refreshToken = refresh;
    await _storage.saveTokens(access, refresh);
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (_) {}
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    await _storage.clearTokens();
    notifyListeners();
  }
}
