import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/features/authentication/presentation/pages/otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: '962',
    countryCode: 'JO',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Jordan',
    example: 'Jordan',
    displayName: 'Jordan',
    displayNameNoCountryCode: 'JO',
    e164Key: '',
  );

  @override
  void initState() {
    super.initState();
    _loadSelectedCountry();
  }

  Future<void> _loadSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final countryCode = prefs.getString('selected_country') ?? 'JO';
    final phoneCode = prefs.getString('selected_phone_code') ?? '962';

    final countryPhoneMap = {
      'JO': {'phoneCode': '962', 'name': 'Jordan'},
      'SY': {'phoneCode': '963', 'name': 'Syria'},
    };

    final countryData = countryPhoneMap[countryCode];
    if (countryData != null) {
      setState(() {
        selectedCountry = Country(
          phoneCode: phoneCode,
          countryCode: countryCode,
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: countryData['name']!,
          example: countryData['name']!,
          displayName: countryData['name']!,
          displayNameNoCountryCode: countryCode,
          e164Key: '',
        );
      });
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimensions.paddingXXL),

                // Logo and Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusXL),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: AppDimensions.elevationL,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: AppDimensions.iconSizeXL,
                        ),
                      ),
                      SizedBox(height: AppDimensions.paddingL),
                      Text(
                        'Enter your phone number',
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: AppDimensions.fontSizeTitle,
                        ),
                      ),
                      SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'We will send you a verification code',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.paddingXXL),

                // Phone Input
                Container(
                  height: AppDimensions.inputFieldHeight,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border.all(color: AppTheme.dividerColor),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: AppDimensions.elevationS,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Country Picker
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountry = country;
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingM,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Flag
                              Container(
                                width: 28.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.r),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        selectedCountry.flagEmoji,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: AppDimensions.paddingS),

                              // Country Code (Responsive)
                              Container(
  constraints: BoxConstraints(
    minWidth: 40.w,
    maxWidth: 70.w,
  ),
  padding: EdgeInsets.symmetric(
    horizontal: 6.w,
    vertical: 2.h,
  ),
  decoration: BoxDecoration(
    color: AppTheme.primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(4.r),
  ),
  child: FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      '+${selectedCountry.phoneCode}',
      style: AppTheme.bodyStyle.copyWith(
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor,
        fontSize: 14.sp * 1.1, // ⬅️ 10% larger
      ),
    ),
  ),
),

                              Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.textSecondaryColor,
                                size: AppDimensions.iconSizeM,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Divider
                      Container(
                        height: 30.h,
                        width: 1,
                        color: AppTheme.dividerColor,
                      ),

                      // Phone Number Input
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTheme.bodyStyle,
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            hintStyle: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingM,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.paddingXXL),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: _sendOTP,
                    style: AppTheme.primaryButtonStyle,
                    child: Text(
                      'Continue',
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
                ),

                SizedBox(height: AppDimensions.paddingL),

                // Terms and Privacy
                Center(
                  child: Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: AppTheme.captionStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendOTP() {
    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final phoneNumber =
        '+${selectedCountry.phoneCode}${phoneController.text.trim()}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationScreen(
          verificationId: 'mock_verification_id',
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }
}
