class ApiEndpoints {
  // Base endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String trips = '/trips';
  static const String uploads = '/uploads';

  // Authentication endpoints
  static const String sendOtp = '$auth/send-otp';
  static const String verifyOtp = '$auth/verify-otp';
  static const String refreshToken = '$auth/refresh-token';
  static const String googleSignIn = '$auth/google-signin';
  static const String logout = '$auth/logout';

  // User endpoints
  static const String createUser = '$users/create';
  static const String getUserProfile = '$users/profile';
  static const String updateUserProfile = '$users/profile';
  static const String checkUserExists = '$users/exists';
  static const String checkUserBlocked = '$users/blocked-status';

  // File upload endpoints
  static const String uploadProfileImage = '$uploads/profile-image';
  static const String uploadDocument = '$uploads/document';

  // Trip endpoints
  static const String createTrip = '$trips/create';
  static const String getTripHistory = '$trips/history';
  static const String getTripDetails = '$trips/details';
}
