import 'package:flutter/material.dart';
import 'package:itspass_user/features/onboarding/presentation/pages/select_country_screen.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Always show SelectCountryScreen as the first screen
    return const SelectCountryScreen();
  }
}
