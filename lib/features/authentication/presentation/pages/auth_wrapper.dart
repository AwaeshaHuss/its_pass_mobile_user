import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:uber_users_app/features/authentication/presentation/pages/phone_auth_screen.dart';
import 'package:uber_users_app/features/authentication/presentation/pages/user_info_screen.dart';
import 'package:uber_users_app/pages/blocked_screen.dart';
import 'package:uber_users_app/pages/home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when the widget initializes
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.read<AuthBloc>().add(const GetUserDataEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show loading while checking authentication
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show error state
        if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        context.read<AuthBloc>().add(const GetUserDataEvent());
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // User is authenticated and data is loaded
        if (state is Authenticated) {
          // Check if user is blocked
          if (state.user.blockStatus == 'yes') {
            return const BlockedScreen();
          }
          
          // Check if user profile is complete
          if (state.user.name.isEmpty || state.user.email.isEmpty) {
            return UserInfoScreen(
              userId: state.user.id,
              phoneNumber: state.user.phone,
            );
          }
          
          // User is authenticated and profile is complete
          return const HomePage();
        }

        // User data loaded but needs profile completion
        if (state is UserDataLoaded) {
          if (state.user.blockStatus == 'yes') {
            return const BlockedScreen();
          }
          
          if (state.user.name.isEmpty || state.user.email.isEmpty) {
            return UserInfoScreen(
              userId: state.user.id,
              phoneNumber: state.user.phone,
            );
          }
          
          return const HomePage();
        }

        // User blocked
        if (state is UserBlockedResult && state.isBlocked) {
          return const BlockedScreen();
        }

        // Default: Show phone authentication screen
        return const PhoneAuthScreen();
      },
    );
  }
}
