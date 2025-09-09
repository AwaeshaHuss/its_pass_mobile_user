import 'package:uber_users_app/core/utils/typedef.dart';
import 'package:uber_users_app/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  ResultVoid signInWithPhone({
    required String phoneNumber,
  });

  ResultFuture<UserEntity> verifyOTP({
    required String verificationId,
    required String smsCode,
  });

  ResultVoid saveUserData({
    required UserEntity user,
  });

  ResultFuture<UserEntity> getUserData();

  ResultFuture<bool> checkUserExists({String? email, String? phone});

  ResultFuture<bool> checkUserBlocked();

  ResultFuture<bool> checkUserFieldsFilled();

  ResultFuture<UserEntity> signInWithGoogle();

  ResultVoid signOut();
}
