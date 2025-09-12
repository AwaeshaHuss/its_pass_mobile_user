import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';

class InfoDialog extends StatelessWidget {
  final String? title, description;
  const InfoDialog({super.key, this.title, this.description});

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
                  color: AppTheme.infoColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppTheme.infoColor,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              
              SizedBox(height: AppDimensions.paddingL),
              
              // Title
              if (title != null)
                Text(
                  title!,
                  style: AppTheme.headingStyle.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              if (title != null) SizedBox(height: AppDimensions.paddingM),
              
              // Description
              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              
              SizedBox(height: AppDimensions.paddingXL),
              
              // OK Button
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightM,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Restart.restartApp(); // TODO: Temporarily commented out
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: Text(
                    "OK",
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
}
