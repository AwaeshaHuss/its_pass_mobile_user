class AppConstants {
  // API Collections/Endpoints
  static const String usersCollection = 'users';
  static const String driversCollection = 'drivers';
  static const String tripsCollection = 'trips';
  
  // Map Constants
  static const double defaultZoom = 14.0;
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 1000);
  
  // Error Messages
  static const String networkError = 'Network connection failed';
  static const String authError = 'Authentication failed';
  static const String locationError = 'Location access denied';
  static const String unknownError = 'An unknown error occurred';
  
  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registrationSuccess = 'Registration successful';
  static const String profileUpdateSuccess = 'Profile updated successfully';
}
