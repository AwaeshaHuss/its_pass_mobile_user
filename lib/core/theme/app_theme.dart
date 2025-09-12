import 'package:flutter/material.dart';
import 'package:uber_users_app/core/constants/app_dimensions.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryLightColor = Color(0xFF4CAF50);
  static const Color primaryDarkColor = Color(0xFF1B5E20);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFFF8C00);
  static const Color infoColor = Color(0xFF3182CE);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLightColor],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, Color(0xFFFFC107)],
  );

  // Text Styles
  static TextStyle get headingStyle => TextStyle(
        fontSize: AppDimensions.fontSizeHeading,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get titleStyle => TextStyle(
        fontSize: AppDimensions.fontSizeTitle,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      );

  static TextStyle get subtitleStyle => TextStyle(
        fontSize: AppDimensions.fontSizeL,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      );

  static TextStyle get bodyStyle => TextStyle(
        fontSize: AppDimensions.fontSizeM,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      );

  static TextStyle get captionStyle => TextStyle(
        fontSize: AppDimensions.fontSizeS,
        fontWeight: FontWeight.normal,
        color: textSecondaryColor,
      );

  static TextStyle get buttonTextStyle => TextStyle(
        fontSize: AppDimensions.fontSizeL,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, AppDimensions.buttonHeightL),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        elevation: AppDimensions.elevationM,
      );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        minimumSize: Size(double.infinity, AppDimensions.buttonHeightL),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        side: const BorderSide(color: primaryColor, width: 2),
      );

  // Input Decoration
  static InputDecoration getInputDecoration({
    required String hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
      );

  // Card Style
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppDimensions.elevationM,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // App Bar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: AppDimensions.elevationM,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppDimensions.fontSizeXL,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
}
