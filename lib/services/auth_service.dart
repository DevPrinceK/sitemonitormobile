import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService api;
  AuthService(this.api);

  Future<Map<String, String>> login(String username, String password) async {
    final res = await api.post('/api/auth/login/',
        data: {'username': username, 'password': password});
    final data = res.data as Map<String, dynamic>;
    return {
      'access': data['access'] as String,
      'refresh': data['refresh'] as String,
    };
  }

  Future<void> register(String username, String password) async {
    await api.post('/api/auth/register/',
        data: {'username': username, 'password': password});
  }

  Future<void> logout() async {
    try {
      await api.post('/api/auth/logout/');
    } on DioException {
      // ignore network errors on logout
    }
  }

  Future<User> currentUser() async {
    final res = await api.get('/api/auth/me/');
    return User.fromJson(res.data as Map<String, dynamic>);
  }
}
