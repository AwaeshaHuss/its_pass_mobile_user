import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/features/authentication/domain/entities/user_entity.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_event.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_state.dart';
import 'package:itspass_user/methods/common_methods.dart';
import 'package:itspass_user/pages/home_page.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserDataSaved || state is Authenticated) {
          // Navigate to home screen when user data is saved
          navigateToHomeScreen();
        } else if (state is AuthError) {
          commonMethods.displaySnackBar(state.message, context);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          bool isLoading = state is AuthLoading;
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
                            onPressed: isLoading ? null : saveUserDataToFireStore,
                            style: AppTheme.primaryButtonStyle,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
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
        },
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

  // store user data via BLoC
  void saveUserDataToFireStore() async {
    if (nameController.text.length >= 3) {
      // Create user entity and use BLoC to save
      final userEntity = UserEntity(
        id: "temp_id_${DateTime.now().millisecondsSinceEpoch}",
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: gmailController.text.trim(),
        blockStatus: "no",
      );

      // Use BLoC to save user data
      context.read<AuthBloc>().add(SaveUserDataEvent(user: userEntity));
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
