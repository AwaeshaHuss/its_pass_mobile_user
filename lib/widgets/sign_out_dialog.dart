import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_users_app/core/constants/app_dimensions.dart';
import 'package:uber_users_app/core/theme/app_theme.dart';

class SignOutDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback onSignOut;

  const SignOutDialog(
      {super.key, this.title, this.description, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: AppDimensions.elevationL,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  color: AppTheme.errorColor,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              
              SizedBox(height: AppDimensions.paddingL),
              
              // Title
              Text(
                title ?? 'Logout',
                style: AppTheme.headingStyle.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: AppDimensions.paddingM),
              
              // Description
              Text(
                description ?? 'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: AppTheme.bodyStyle.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              
              SizedBox(height: AppDimensions.paddingXL),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppDimensions.buttonHeightM,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.dividerColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: AppDimensions.paddingM),
                  
                  Expanded(
                    child: SizedBox(
                      height: AppDimensions.buttonHeightM,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onSignOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: AppTheme.bodyStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
