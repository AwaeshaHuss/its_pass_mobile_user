import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itspass_user/core/errors/exceptions.dart';
import 'package:itspass_user/features/authentication/data/models/user_model.dart';

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
    required GoogleSignIn googleSignIn,
    required SharedPreferences sharedPreferences,
  })  : _googleSignIn = googleSignIn,
        _sharedPreferences = sharedPreferences;

  final GoogleSignIn _googleSignIn;
  final SharedPreferences _sharedPreferences;

  @override
  Future<void> signInWithPhone({required String phoneNumber}) async {
    // Mock OTP sending - simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // In offline mode, always succeed
  }

  @override
  Future<UserModel> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    // Mock OTP verification - simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In offline mode, accept any OTP and create mock user
    final mockUser = UserModel(
      id: 'user_${phoneNumber.replaceAll('+', '').replaceAll(' ', '')}',
      name: 'User ${phoneNumber.substring(phoneNumber.length - 4)}',
      email: 'user${phoneNumber.substring(phoneNumber.length - 4)}@itspass.com',
      phone: phoneNumber,
      blockStatus: 'no',
    );

    // Create mock token
    final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    await _sharedPreferences.setString('auth_token', mockToken);
    
    // Store user data
    await _storeUserData(mockUser);

    return mockUser;
  }

  @override
  Future<void> saveUserData({required UserModel user}) async {
    // Mock user data saving - simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In offline mode, just store locally
    await _storeUserData(user);
  }

  @override
  Future<UserModel> getUserData() async {
    // First try to get from local storage
    final localUserData = _sharedPreferences.getString('user_data');
    final token = _sharedPreferences.getString('auth_token');
    
    if (localUserData != null && token != null) {
      final userData = UserModel.fromJson(localUserData);
      return userData;
    }

    // If no local data or token, throw exception to show auth screens
    throw const ServerException(
      message: 'User not authenticated',
      statusCode: '401',
    );
  }

  @override
  Future<bool> checkUserExists({String? email, String? phone}) async {
    // Mock user existence check - simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In offline mode, always return false (user doesn't exist)
    return false;
  }

  @override
  Future<bool> checkUserBlocked() async {
    // Mock user blocked check - simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In offline mode, always return false (user is not blocked)
    return false;
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
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const ServerException(
        message: 'Google sign-in cancelled',
        statusCode: '401',
      );
    }

    // Mock Google sign-in - simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Create mock user from Google account info
    final mockUser = UserModel(
      id: 'google_${googleUser.id}',
      name: googleUser.displayName ?? 'Google User',
      email: googleUser.email,
      phone: '+1234567890', // Default phone for Google users
      blockStatus: 'no',
    );

    // Create mock token
    final mockToken = 'google_token_${DateTime.now().millisecondsSinceEpoch}';
    await _sharedPreferences.setString('auth_token', mockToken);
    
    // Store user data
    await _storeUserData(mockUser);

    return mockUser;
  }

  @override
  Future<void> signOut() async {
    // Mock sign out - simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Sign out from Google (if signed in)
    await _googleSignIn.signOut();
    
    // Clear local storage
    await _clearLocalData();
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
    return token != null;
  }
}
