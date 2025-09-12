import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:itspass_user/appInfo/app_info.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:itspass_user/features/onboarding/presentation/pages/app_wrapper.dart';
import 'package:itspass_user/features/settings/providers/language_provider.dart';
import 'package:itspass_user/injection/injection.dart';
import 'package:itspass_user/generated/l10n/app_localizations.dart';

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
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return MaterialApp(
                title: 'ItsPass User',
                debugShowCheckedModeBanner: false,
                locale: languageProvider.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
                  useMaterial3: true,
                  fontFamily: 'Roboto',
                ),
                home: const AppWrapper(),
              );
            },
          );
        },
      ),
    );
  }
}

// This class is deprecated - using AuthWrapper with BLoC pattern instead
