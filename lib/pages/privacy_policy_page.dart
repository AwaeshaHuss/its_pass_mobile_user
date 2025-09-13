import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: AppDimensions.iconSizeM,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: AppTheme.headingStyle.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: AppDimensions.elevationS,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    ),
                    child: Icon(
                      Icons.privacy_tip,
                      color: AppTheme.primaryColor,
                      size: 30.sp,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'Your Privacy Matters',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: AppTheme.captionStyle.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppDimensions.paddingL),
            
            // Privacy Policy Content
            _buildSection(
              'Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, request a ride, or contact us for support.',
              Icons.info_outline,
            ),
            
            _buildSection(
              'Location Information',
              'We collect precise location data when you use our services to provide rides, calculate fares, and improve our services.',
              Icons.location_on,
            ),
            
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.',
              Icons.settings,
            ),
            
            _buildSection(
              'Information Sharing',
              'We may share your information with drivers, service providers, and in certain legal circumstances as described in this policy.',
              Icons.share,
            ),
            
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
              Icons.security,
            ),
            
            _buildSection(
              'Your Rights',
              'You have the right to access, update, or delete your personal information. You can also opt out of certain communications.',
              Icons.account_circle,
            ),
            
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@itspass.com',
              Icons.contact_mail,
            ),
            
            SizedBox(height: AppDimensions.paddingXL),
            
            // Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: AppTheme.primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'We are committed to protecting your privacy and ensuring the security of your personal information.',
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppDimensions.paddingL),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingL),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppDimensions.elevationS,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            content,
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
