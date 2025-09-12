import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_state.dart';
import 'package:itspass_user/features/onboarding/presentation/pages/select_country_screen.dart';
import 'package:itspass_user/pages/home_page.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');
      
      setState(() {
        _isAuthenticated = token != null && userData != null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() {
            _isAuthenticated = true;
          });
        } else if (state is Unauthenticated || state is AuthInitial) {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: _isAuthenticated ? const HomePage() : const SelectCountryScreen(),
    );
  }
}
