import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:uber_users_app/core/errors/exceptions.dart';
import 'package:uber_users_app/core/network/api_client.dart';
import 'package:uber_users_app/core/network/api_endpoints.dart';

@lazySingleton
class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  // Authentication API calls
  Future<Map<String, dynamic>> sendOtp({required String phoneNumber}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.sendOtp,
        data: {'phone_number': phoneNumber},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to send OTP',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to verify OTP',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  Future<Map<String, dynamic>> googleSignIn({
    required String idToken,
    required String accessToken,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.googleSignIn,
        data: {
          'id_token': idToken,
          'access_token': accessToken,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to sign in with Google',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  // User API calls
  Future<Map<String, dynamic>> createUser({
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.createUser,
        data: userData,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to create user',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getUserProfile);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to get user profile',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateUserProfile,
        data: userData,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update user profile',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  Future<bool> checkUserExists({String? email, String? phone}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.checkUserExists,
        queryParameters: {
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
        },
      );
      return response.data['exists'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to check user existence',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  Future<bool> checkUserBlocked() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.checkUserBlocked);
      return response.data['blocked'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to check user blocked status',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  // File upload API calls
  Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    required String endpoint,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _apiClient.dio.post(
        endpoint,
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to upload file',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.dio.post(ApiEndpoints.logout);
      await _apiClient.clearAuthToken();
    } on DioException catch (e) {
      // Even if logout fails on server, clear local tokens
      await _apiClient.clearAuthToken();
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to logout',
        statusCode: e.response?.statusCode.toString() ?? '500',
      );
    }
  }
}
