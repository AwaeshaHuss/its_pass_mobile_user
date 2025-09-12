import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Firebase imports removed - using API-based services
import 'package:itspass_user/authentication/user_information_screen.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/generated/l10n/app_localizations.dart';
import 'package:itspass_user/methods/common_methods.dart';
import 'package:itspass_user/pages/home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  CommonMethods commonMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // TODO: Replace with BLoC pattern
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimensions.paddingXL),
                Text(
                  localizations.enterPhoneNumber,
                  style: AppTheme.titleStyle,
                ),
                SizedBox(height: AppDimensions.paddingS),
                Container(
                  height: AppDimensions.inputFieldHeight,
                  child: TextFormField(
                    controller: phoneController,
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                      });
                    },
                    decoration: AppTheme.getInputDecoration(
                      hintText: '313 7426256',
                    ).copyWith(
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.paddingS,
                      ),
                      prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(
                          AppDimensions.paddingS,
                          AppDimensions.paddingS,
                          AppDimensions.paddingS,
                          AppDimensions.paddingS,
                        ),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                bottomSheetHeight: 400.h,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                            );
                          },
                          child: Text(
                            ' +${selectedCountry.phoneCode}',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: phoneController.text.length > 9
                          ? Container(
                              height: AppDimensions.iconSizeM,
                              width: AppDimensions.iconSizeM,
                              margin: EdgeInsets.all(AppDimensions.paddingS),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor,
                              ),
                              child: Icon(
                                Icons.done,
                                size: AppDimensions.iconSizeS,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingL),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: sendPhoneNumber,
                    style: AppTheme.primaryButtonStyle,
                    child: Text(
                      localizations.continueText,
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 0,
                        color: AppTheme.dividerColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                      ),
                      child: Text(
                        localizations.or,
                        style: AppTheme.captionStyle,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppTheme.dividerColor,
                        endIndent: 0,
                      ),
                    )
                  ],
                ),
                SizedBox(height: AppDimensions.paddingL),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Google Sign-In with API
                      navigate(isSingedIn: false);
                    },
                    style: AppTheme.secondaryButtonStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.g_mobiledata,
                          color: AppTheme.primaryColor,
                          size: AppDimensions.iconSizeM,
                        ),
                        SizedBox(width: AppDimensions.paddingS),
                        Text(
                          localizations.signInWithGoogle,
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Apple Sign-In
                    },
                    style: AppTheme.secondaryButtonStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apple,
                          color: AppTheme.primaryColor,
                          size: AppDimensions.iconSizeM,
                        ),
                        SizedBox(width: AppDimensions.paddingS),
                        Text(
                          "Continue with Apple",
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingXL),
                Text(
                  "By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated means, from ItsPass and its affiliates to the number provided.",
                  textAlign: TextAlign.center,
                  style: AppTheme.captionStyle.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    // TODO: Replace with API-based phone verification
    String phoneNumber = phoneController.text.trim();

    // Validate the phone number
    if (phoneNumber.isEmpty ||
        phoneNumber.length != 10 ||
        !RegExp(r'^[3][0-9]{9}$').hasMatch(phoneNumber)) {
      // Show error if the phone number is invalid
      commonMethods.displaySnackBar(
        "Please enter a valid mobile number.",
        context,
      );
      return;
    }

    // Append country code
    String fullPhoneNumber = '+${selectedCountry.phoneCode}$phoneNumber';

    // TODO: Implement API-based phone verification
    // For now, navigate to user information screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      ),
    );
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
