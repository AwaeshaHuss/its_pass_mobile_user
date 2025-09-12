import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
