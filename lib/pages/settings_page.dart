import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/generated/l10n/app_localizations.dart';
import 'package:itspass_user/features/settings/providers/language_provider.dart';
import 'package:itspass_user/features/onboarding/presentation/pages/select_country_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.currentLanguage == 'ar';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.settings,
          style: AppTheme.headingStyle.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppDimensions.paddingM),
            
            // Language & Region Section
            _buildSectionHeader(
              isArabic ? 'اللغة والمنطقة' : 'Language & Region',
            ),
            SizedBox(height: AppDimensions.paddingS),
            
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.language,
                title: isArabic ? 'اللغة' : 'Language',
                subtitle: isArabic ? 'العربية' : 'English',
                onTap: () => _showLanguageDialog(context, languageProvider),
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.public,
                title: isArabic ? 'البلد/المنطقة' : 'Country/Region',
                subtitle: isArabic ? 'الأردن' : 'Jordan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectCountryScreen(),
                    ),
                  );
                },
              ),
            ]),
            
            SizedBox(height: AppDimensions.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.headingStyle.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingS,
      ),
      leading: Container(
        width: AppDimensions.iconSizeL + 8,
        height: AppDimensions.iconSizeL + 8,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: AppDimensions.iconSizeM,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.bodyStyle.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyStyle.copyWith(
          color: AppTheme.textSecondaryColor,
          fontSize: 14.sp,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppDimensions.iconSizeS,
        color: AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppTheme.dividerColor,
      thickness: 1,
      indent: AppDimensions.paddingL + AppDimensions.iconSizeL + 8 + AppDimensions.paddingM,
      endIndent: AppDimensions.paddingL,
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    final isArabic = languageProvider.currentLanguage == 'ar';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          title: Text(
            isArabic ? 'اختر اللغة' : 'Select Language',
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                languageProvider,
                'ar',
                'العربية',
                'Arabic',
                '🇯🇴',
              ),
              SizedBox(height: AppDimensions.paddingS),
              _buildLanguageOption(
                context,
                languageProvider,
                'en',
                'English',
                'الإنجليزية',
                '🇺🇸',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    String code,
    String name,
    String altName,
    String flag,
  ) {
    final isSelected = languageProvider.currentLanguage == code;
    final isArabic = languageProvider.currentLanguage == 'ar';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await languageProvider.setLanguage(code);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? AppTheme.primaryColor
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Row(
            children: [
              Text(
                flag,
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Text(
                  isArabic ? (code == 'ar' ? name : altName) : name,
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
