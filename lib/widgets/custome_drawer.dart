import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_users_app/core/constants/app_dimensions.dart';
import 'package:uber_users_app/core/theme/app_theme.dart';
import 'package:uber_users_app/global/global_var.dart';
import 'package:uber_users_app/pages/about_page.dart';
import 'package:uber_users_app/pages/profile_page.dart';
import 'package:uber_users_app/pages/trips_history_page.dart';
import 'package:uber_users_app/widgets/sign_out_dialog.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
    // TODO: Replace with BLoC pattern
    // final AuthenticationProvider
      // authProvider; // Pass the auth provider for sign out

  const CustomDrawer({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surfaceColor,
      width: 280.w,
      child: Column(
        children: [
          // Custom Header
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppDimensions.radiusXL),
                bottomRight: Radius.circular(AppDimensions.radiusXL),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: AppDimensions.elevationM,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40.w,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/images/avatarman.png",
                          width: 60.w,
                          height: 60.w,
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    Text(
                      userName,
                      style: AppTheme.headingStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingS),
                    Text(
                      userEmail,
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingM,
                horizontal: AppDimensions.paddingS,
              ),
              children: [

                _buildDrawerItem(
                  icon: Icons.person,
                  title: "My Profile",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.history,
                  title: "Trip History",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TripsHistoryPage()),
                    );
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: "Settings",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement settings functionality
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.privacy_tip,
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement privacy functionality
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement help functionality
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: "About",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.star_rate,
                  title: "Rate Us",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement rate us functionality
                  },
                ),
                
                Divider(
                  color: AppTheme.dividerColor,
                  thickness: 1,
                  indent: AppDimensions.paddingL,
                  endIndent: AppDimensions.paddingL,
                ),
                
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: "Logout",
                  iconColor: AppTheme.errorColor,
                  textColor: AppTheme.errorColor,
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SignOutDialog(
                          title: 'Logout',
                          description: 'Are you sure you want to logout?',
                          onSignOut: () async {
                            // TODO: Replace with BLoC pattern
                            // signOut(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingXS,
        horizontal: AppDimensions.paddingS,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        leading: Container(
          width: AppDimensions.iconSizeL + 8,
          height: AppDimensions.iconSizeL + 8,
          decoration: BoxDecoration(
            color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppTheme.primaryColor,
            size: AppDimensions.iconSizeM,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.bodyStyle.copyWith(
            color: textColor ?? AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppDimensions.iconSizeS,
          color: AppTheme.textSecondaryColor,
        ),
        onTap: onTap,
        hoverColor: AppTheme.primaryColor.withOpacity(0.05),
        splashColor: AppTheme.primaryColor.withOpacity(0.1),
      ),
    );
  }
}
