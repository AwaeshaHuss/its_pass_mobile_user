import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_users_app/core/errors/exceptions.dart';
import 'package:uber_users_app/core/network/api_service.dart';
import 'package:uber_users_app/features/authentication/data/models/user_model.dart';

abstract class AuthApiDataSource {
  Future<void> signInWithPhone({required String phoneNumber});
  Future<UserModel> verifyOTP({
    required String phoneNumber,
    required String otp,
  });
  Future<void> saveUserData({required UserModel user});
  Future<UserModel> getUserData();
  Future<bool> checkUserExists({String? email, String? phone});
  Future<bool> checkUserBlocked();
  Future<bool> checkUserFieldsFilled();
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
}

@LazySingleton(as: AuthApiDataSource)
class AuthApiDataSourceImpl implements AuthApiDataSource {
  const AuthApiDataSourceImpl({
    required ApiService apiService,
    required GoogleSignIn googleSignIn,
    required SharedPreferences sharedPreferences,
  })  : _apiService = apiService,
        _googleSignIn = googleSignIn,
        _sharedPreferences = sharedPreferences;

  final ApiService _apiService;
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _sharedPreferences;

  @override
  Future<void> signInWithPhone({required String phoneNumber}) async {
    try {
      await _apiService.sendOtp(phoneNumber: phoneNumber);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _apiService.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      // Extract token and user data from response
      final token = response['token'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      if (token == null || userData == null) {
        throw const ServerException(
          message: 'Invalid response from server',
          statusCode: '500',
        );
      }

      // Store token
      await _sharedPreferences.setString('auth_token', token);
      
      // Store user data
      final userModel = UserModel.fromMap(userData);
      await _storeUserData(userModel);

      return userModel;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> saveUserData({required UserModel user}) async {
    try {
      await _apiService.createUser(userData: user.toMap());
      await _storeUserData(user);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      // First try to get from local storage
      final localUserData = _sharedPreferences.getString('user_data');
      if (localUserData != null) {
        final userData = UserModel.fromJson(localUserData);
        
        // Check if token is still valid
        final token = _sharedPreferences.getString('auth_token');
        if (token != null && !JwtDecoder.isExpired(token)) {
          return userData;
        }
      }

      // If no local data or token expired, fetch from API
      final response = await _apiService.getUserProfile();
      final userModel = UserModel.fromMap(response['user']);
      await _storeUserData(userModel);
      
      return userModel;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<bool> checkUserExists({String? email, String? phone}) async {
    try {
      return await _apiService.checkUserExists(email: email, phone: phone);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<bool> checkUserBlocked() async {
    try {
      return await _apiService.checkUserBlocked();
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<bool> checkUserFieldsFilled() async {
    try {
      final userData = await getUserData();
      return userData.id.isNotEmpty &&
          userData.name.isNotEmpty &&
          userData.email.isNotEmpty &&
          userData.phone.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerException(
          message: 'Google sign-in cancelled',
          statusCode: '401',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final response = await _apiService.googleSignIn(
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      // Extract token and user data from response
      final token = response['token'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      if (token == null || userData == null) {
        throw const ServerException(
          message: 'Invalid response from server',
          statusCode: '500',
        );
      }

      // Store token
      await _sharedPreferences.setString('auth_token', token);
      
      // Store user data
      final userModel = UserModel.fromMap(userData);
      await _storeUserData(userModel);

      return userModel;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _apiService.logout(),
        _googleSignIn.signOut(),
      ]);
      
      // Clear local storage
      await _clearLocalData();
    } catch (e) {
      // Even if server logout fails, clear local data
      await _clearLocalData();
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  Future<void> _storeUserData(UserModel user) async {
    await _sharedPreferences.setString('user_data', user.toJson());
  }

  Future<void> _clearLocalData() async {
    await Future.wait([
      _sharedPreferences.remove('auth_token'),
      _sharedPreferences.remove('refresh_token'),
      _sharedPreferences.remove('user_data'),
    ]);
  }

  bool get isAuthenticated {
    final token = _sharedPreferences.getString('auth_token');
    return token != null && !JwtDecoder.isExpired(token);
  }
}
