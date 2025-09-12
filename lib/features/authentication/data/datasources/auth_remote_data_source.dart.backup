import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:uber_users_app/core/errors/exceptions.dart';
import 'package:uber_users_app/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signInWithPhone({required String phoneNumber});
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String smsCode,
  });
  Future<void> saveUserData({required UserModel user});
  Future<UserModel> getUserData();
  Future<bool> checkUserExists({String? email, String? phone});
  Future<bool> checkUserBlocked();
  Future<bool> checkUserFieldsFilled();
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseDatabase firebaseDatabase,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseDatabase = firebaseDatabase,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _firebaseDatabase;
  final GoogleSignIn _googleSignIn;

  @override
  Future<void> signInWithPhone({required String phoneNumber}) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw ServerException(
            message: e.message ?? 'Phone verification failed',
            statusCode: e.code,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // This will be handled by the BLoC
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout if needed
        },
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Phone sign-in failed',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw const ServerException(
          message: 'Failed to sign in user',
          statusCode: '401',
        );
      }

      // Check if user data exists in database
      final userData = await _getUserDataFromDatabase(user.uid);
      return userData;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'OTP verification failed',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> saveUserData({required UserModel user}) async {
    try {
      final DatabaseReference usersRef =
          _firebaseDatabase.ref().child("users").child(user.id);
      await usersRef.set(user.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to save user data',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const ServerException(
          message: 'No authenticated user',
          statusCode: '401',
        );
      }

      return await _getUserDataFromDatabase(currentUser.uid);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<bool> checkUserExists({String? email, String? phone}) async {
    try {
      final DatabaseReference usersRef = _firebaseDatabase.ref().child("users");
      
      DatabaseEvent snapshot;
      if (email != null) {
        snapshot = await usersRef.orderByChild("email").equalTo(email).once();
      } else if (phone != null) {
        snapshot = await usersRef.orderByChild("phone").equalTo(phone).once();
      } else {
        return false;
      }

      return snapshot.snapshot.exists;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<bool> checkUserBlocked() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return false;

      final DatabaseReference userRef =
          _firebaseDatabase.ref().child("users").child(currentUser.uid);
      final DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final Map userData = snapshot.value as Map;
        final String blockStatus = userData["blockStatus"] ?? 'no';
        return blockStatus == 'yes';
      }
      return false;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<bool> checkUserFieldsFilled() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return false;

      final DatabaseReference userRef =
          _firebaseDatabase.ref().child("users").child(currentUser.uid);
      final DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final Map userData = snapshot.value as Map;
        final String id = userData["id"] ?? '';
        final String name = userData["name"] ?? '';
        final String email = userData["email"] ?? '';
        final String phone = userData["phone"] ?? '';

        return id.isNotEmpty && name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty;
      }
      return false;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerException(
          message: 'Google sign-in cancelled',
          statusCode: '401',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw const ServerException(
          message: 'Failed to sign in with Google',
          statusCode: '401',
        );
      }

      // Try to get existing user data or create new user model
      try {
        return await _getUserDataFromDatabase(user.uid);
      } catch (e) {
        // If user doesn't exist in database, create a new user model
        return UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          blockStatus: 'no',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Google sign-in failed',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  Future<UserModel> _getUserDataFromDatabase(String uid) async {
    final DatabaseReference userRef =
        _firebaseDatabase.ref().child("users").child(uid);
    final DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists && snapshot.value != null) {
      final Map<dynamic, dynamic> userData =
          snapshot.value as Map<dynamic, dynamic>;
      return UserModel.fromMap(Map<String, dynamic>.from(userData));
    } else {
      throw const ServerException(
        message: 'User data not found',
        statusCode: '404',
      );
    }
  }
}
