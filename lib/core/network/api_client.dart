import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ApiClient {
  late final Dio _dio;
  final SharedPreferences _prefs;

  ApiClient(this._prefs) {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://your-api-base-url.com/api/v1', // Replace with your API base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to requests
          final token = _prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle token expiration
          if (error.response?.statusCode == 401) {
            _handleTokenExpiration();
          }
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void _handleTokenExpiration() {
    _prefs.remove('auth_token');
    _prefs.remove('refresh_token');
    _prefs.remove('user_data');
    // Navigate to login screen - this would be handled by the app state
  }

  Future<void> setAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('user_data');
  }

  String? getAuthToken() {
    return _prefs.getString('auth_token');
  }
}
