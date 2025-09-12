import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/global/global_var.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

  setDriverInfo() {
    setState(() {
      nameTextEditingController.text = userName;
      phoneTextEditingController.text = userPhone;
      emailTextEditingController.text = userEmail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: AppDimensions.elevationM,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: AppTheme.titleStyle.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            children: [
              SizedBox(height: AppDimensions.paddingXL),
              
              // Profile Image
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: AppDimensions.elevationL,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60.w,
                  backgroundColor: AppTheme.primaryLightColor.withOpacity(0.1),
                  child: Image.asset(
                    "assets/images/avatarman.png",
                    width: 80.w,
                    height: 80.w,
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.paddingXXL),

              // Profile Information
              _buildProfileField(
                controller: nameTextEditingController,
                label: "Full Name",
                icon: Icons.person,
              ),
              
              SizedBox(height: AppDimensions.paddingL),
              
              _buildProfileField(
                controller: phoneTextEditingController,
                label: "Phone Number",
                icon: Icons.phone,
              ),
              
              SizedBox(height: AppDimensions.paddingL),
              
              _buildProfileField(
                controller: emailTextEditingController,
                label: "Email Address",
                icon: Icons.email,
              ),
              
              SizedBox(height: AppDimensions.paddingXXL),
              
              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightL,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement edit profile functionality
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: Text(
                    "Edit Profile",
                    style: AppTheme.buttonTextStyle,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        SizedBox(height: AppDimensions.paddingS),
        Container(
          height: AppDimensions.inputFieldHeight,
          child: TextFormField(
            controller: controller,
            enabled: false,
            style: AppTheme.bodyStyle,
            decoration: AppTheme.getInputDecoration(
              hintText: '',
              prefixIcon: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: AppDimensions.iconSizeM,
              ),
            ).copyWith(
              filled: true,
              fillColor: AppTheme.surfaceColor.withOpacity(0.7),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
