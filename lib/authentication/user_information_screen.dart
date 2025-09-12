import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/methods/common_methods.dart';
import 'package:itspass_user/pages/home_page.dart';

import '../models/user_model.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  CommonMethods commonMethods = CommonMethods();
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    gmailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TODO: Initialize with user data from API
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BLoC pattern

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: AppDimensions.elevationM,
        centerTitle: true,
        title: Text(
          'Profile Setup',
          style: AppTheme.titleStyle.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingXL,
                horizontal: AppDimensions.paddingL,
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      // Input Fields
                      _buildInputField(
                        controller: nameController,
                        hintText: 'Enter Your Full Name',
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                        maxLength: 25,
                      ),

                      SizedBox(height: AppDimensions.paddingL),
                      
                      _buildInputField(
                        controller: gmailController,
                        hintText: 'Enter Your Email Address',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 50,
                      ),
                      
                      SizedBox(height: AppDimensions.paddingL),
                      
                      _buildInputField(
                        controller: phoneController,
                        hintText: 'Enter Your Phone Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        maxLength: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.paddingXXL),
                  
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeightL,
                    child: ElevatedButton(
                      onPressed: saveUserDataToFireStore,
                      style: AppTheme.primaryButtonStyle,
                      child: Text(
                        "Continue",
                        style: AppTheme.buttonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
    required int maxLength,
  }) {
    return Container(
      height: AppDimensions.inputFieldHeight,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: AppTheme.bodyStyle,
        decoration: AppTheme.getInputDecoration(
          hintText: hintText,
          prefixIcon: Container(
            margin: EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              color: AppTheme.primaryColor,
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconSizeS,
              color: Colors.white,
            ),
          ),
        ).copyWith(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingM,
          ),
        ),
      ),
    );
  }

  // store user data via API
  void saveUserDataToFireStore() async {
    // TODO: Implement API-based user data saving
    UserModel userModel = UserModel(
        id: "temp_id", // TODO: Get from API response
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: gmailController.text.trim(),
        blockStatus: "no");

    if (nameController.text.length >= 3) {
      // TODO: Call API to save user data
      // For now, navigate to home screen
      navigateToHomeScreen();
    } else {
      commonMethods.displaySnackBar(
          'Name must be atleast 3 characters', context);
    }
  }

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }
}
