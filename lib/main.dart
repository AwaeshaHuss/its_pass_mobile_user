import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:uber_users_app/features/authentication/presentation/pages/auth_wrapper.dart';
import 'package:uber_users_app/injection/injection.dart';

late Size mq;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(); // Initialize dependency injection
  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoClass()),
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Uber User App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// This class is deprecated - using AuthWrapper with BLoC pattern instead
