import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/generated/l10n/app_localizations.dart';
import 'package:itspass_user/pages/about_page.dart';
import 'package:itspass_user/pages/profile_page.dart';
import 'package:itspass_user/pages/settings_page.dart';
import 'package:itspass_user/pages/trips_history_page.dart';
import 'package:itspass_user/pages/wallet_screen.dart';
import 'package:itspass_user/widgets/sign_out_dialog.dart';

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
    final localizations = AppLocalizations.of(context);
    String userEmail = "user@example.com"; // TODO: Get from user data
    return Drawer(
      backgroundColor: AppTheme.surfaceColor,
      width: 280.w,
      child: Column(
        children: [
          // Custom Header
          Container(
            height: 210.h,
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
                      width: 70.w,
                      height: 70.w,
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
                        radius: 35.w,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/images/avatarman.png",
                          width: 50.w,
                          height: 50.w,
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingS),
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
                vertical: AppDimensions.paddingS,
                horizontal: AppDimensions.paddingS,
              ),
              children: [

                _buildDrawerItem(
                  icon: Icons.person,
                  title: localizations.myProfile,
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
                  title: localizations.tripHistory,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TripsHistoryPage()),
                    );
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.account_balance_wallet,
                  title: "Wallet",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WalletScreen()),
                    );
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: localizations.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
                
                
                _buildDrawerItem(
                  icon: Icons.privacy_tip,
                  title: localizations.privacyPolicy,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement privacy functionality
                  },
                ),
                
                
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: localizations.about,
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
                  title: localizations.rateUs,
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
                  title: localizations.logout,
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
        vertical: 2.h,
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
