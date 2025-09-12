import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:itspass_user/authentication/user_information_screen.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/generated/l10n/app_localizations.dart';
import 'package:itspass_user/methods/common_methods.dart';
import 'package:itspass_user/pages/home_page.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

CommonMethods commonMethods = CommonMethods();

class _OTPScreenState extends State<OTPScreen> {
  String? smsCode;
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // TODO: Replace with BLoC pattern for OTP verification
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingXL,
              horizontal: AppDimensions.paddingL,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.verifyOTP,
                  style: AppTheme.headingStyle,
                ),
                SizedBox(height: AppDimensions.paddingM),
                Text(
                  localizations.enterOTP,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingXL),

                // OTP Input
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      color: AppTheme.surfaceColor,
                      border: Border.all(
                        color: AppTheme.dividerColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: AppDimensions.elevationS,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    textStyle: AppTheme.titleStyle,
                  ),
                  focusedPinTheme: PinTheme(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      color: AppTheme.surfaceColor,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          blurRadius: AppDimensions.elevationM,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textStyle: AppTheme.titleStyle.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      smsCode = value;
                    });
                    verifyOTP(smsCode: smsCode!);
                  },
                ),

                SizedBox(height: AppDimensions.paddingXXL),
                
                // TODO: Replace with BLoC state management
                const SizedBox.shrink(),

                SizedBox(height: AppDimensions.paddingXL),

                Text(
                  'Didn\'t receive any code?',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),

                SizedBox(height: AppDimensions.paddingM),

                SizedBox(
                  width: 120.w,
                  height: AppDimensions.buttonHeightM,
                  child: ElevatedButton(
                    style: AppTheme.secondaryButtonStyle.copyWith(
                      minimumSize: MaterialStateProperty.all(
                        Size(120.w, AppDimensions.buttonHeightM),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement resend OTP functionality
                    },
                    child: Text(
                      "Resend",
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyOTP({required String smsCode}) async {
    // TODO: Implement OTP verification with BLoC pattern
    // For now, navigate to user information screen
    navigate(isSingedIn: false);
  }

  void navigate({required bool isSingedIn}) {
    if (isSingedIn) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const UserInformationScreen()));
    }
  }
}
