import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/features/authentication/presentation/pages/auth_wrapper.dart';
import 'package:itspass_user/features/settings/providers/language_provider.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  String _selectedCountry = 'JO';
  String _selectedLanguage = 'ar';
  bool _isLoading = false;

  final List<Map<String, String>> _countries = [
    {
      'code': 'JO',
      'name': 'Jordan',
      'nameAr': 'الأردن',
      'flag': '🇯🇴',
    },
    {
      'code': 'SY',
      'name': 'Syria',
      'nameAr': 'سوريا',
      'flag': '🇸🇾',
    },
  ];

  final List<Map<String, String>> _languages = [
    {
      'code': 'ar',
      'name': 'العربية',
      'nameEn': 'Arabic',
      'flag': '🇯🇴',
    },
    {
      'code': 'en',
      'name': 'English',
      'nameAr': 'الإنجليزية',
      'flag': '🇺🇸',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCountry = prefs.getString('selected_country') ?? 'JO';
      _selectedLanguage = prefs.getString('language_code') ?? 'ar';
    });
  }

  Future<void> _savePreferencesAndContinue() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', _selectedCountry);
    await prefs.setString('language_code', _selectedLanguage);
    await prefs.setBool('country_selected', true);

    // Update language provider
    if (mounted) {
      await Provider.of<LanguageProvider>(context, listen: false)
          .setLanguage(_selectedLanguage);
    }

    setState(() {
      _isLoading = false;
    });

    // Navigate directly to AuthWrapper - let it handle authentication logic
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    }
  }

  void _selectCountry(String countryCode) {
    setState(() {
      _selectedCountry = countryCode;
    });
  }

  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _selectedLanguage == 'ar';
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppDimensions.paddingXL * 1),
                
                // Logo and welcome section
                Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: AppDimensions.elevationL,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingL / 2),
                    Text(
                      'ItsPass',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingS),
                    Text(
                      isArabic ? 'مرحباً' : 'Welcome',
                      style: AppTheme.bodyStyle.copyWith(
                        fontSize: 16.sp,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppDimensions.paddingXL / 2),
                
                // Country Selection Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'اختر بلدك' : 'Select Your Country',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingM / 2),
                    
                    // Countries list
                    ..._countries.map((country) {
                      final isSelected = _selectedCountry == country['code'];
                      final countryName = isArabic ? country['nameAr']! : country['name']!;
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.paddingS),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectCountry(country['code']!),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            child: Container(
                              padding: EdgeInsets.all(AppDimensions.paddingM),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppTheme.primaryColor.withOpacity(0.1)
                                    : AppTheme.surfaceColor,
                                border: Border.all(
                                  color: isSelected 
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    country['flag']!,
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                  SizedBox(width: AppDimensions.paddingM),
                                  Expanded(
                                    child: Text(
                                      countryName,
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
                        ),
                      );
                    }).toList(),
                  ],
                ),
                
                SizedBox(height: AppDimensions.paddingXL / 2),
                
                // Language Selection Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'اختر اللغة' : 'Select Language',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingM / 2),
                    
                    // Languages list
                    ..._languages.map((language) {
                      final isSelected = _selectedLanguage == language['code'];
                      final languageName = isArabic 
                          ? (language['code'] == 'ar' ? language['name']! : language['nameAr']!)
                          : (language['code'] == 'en' ? language['name']! : language['nameEn']!);
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.paddingS),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectLanguage(language['code']!),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            child: Container(
                              padding: EdgeInsets.all(AppDimensions.paddingM),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppTheme.primaryColor.withOpacity(0.1)
                                    : AppTheme.surfaceColor,
                                border: Border.all(
                                  color: isSelected 
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    language['flag']!,
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                  SizedBox(width: AppDimensions.paddingM),
                                  Expanded(
                                    child: Text(
                                      languageName,
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
                        ),
                      );
                    }).toList(),
                  ],
                ),
                
                SizedBox(height: AppDimensions.paddingXL / 2),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePreferencesAndContinue,
                    style: AppTheme.primaryButtonStyle,
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isArabic ? 'متابعة' : 'Continue',
                            style: AppTheme.buttonTextStyle,
                          ),
                  ),
                ),
                
                SizedBox(height: AppDimensions.paddingL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
