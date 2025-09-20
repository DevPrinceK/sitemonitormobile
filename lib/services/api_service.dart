import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_config.dart';
import '../providers/auth_provider.dart';

class ApiService {
  final Dio _dio;
  final AuthProvider authProvider;

  ApiService(this.authProvider)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = authProvider.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final reqOptions = e.requestOptions;
            final clone = await _dio.fetch(reqOptions);
            return handler.resolve(clone);
          }
        }
        handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refresh = authProvider.refreshToken;
      if (refresh == null) return false;
      final response =
          await _dio.post('/api/auth/refresh/', data: {'refresh': refresh});
      final data = response.data as Map<String, dynamic>;
      await authProvider.setTokens(data['access'], refresh);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Refresh failed: $e');
      }
      return false;
    }
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post(path, data: data);
  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put(path, data: data);
  Future<Response<T>> delete<T>(String path) => _dio.delete(path);
}
