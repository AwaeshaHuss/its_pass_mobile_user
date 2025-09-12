import 'package:injectable/injectable.dart';
import 'package:itspass_user/core/utils/typedef.dart';
import 'package:itspass_user/features/authentication/domain/entities/user_entity.dart';
import 'package:itspass_user/features/authentication/domain/repositories/auth_repository.dart';

@lazySingleton
class VerifyOTP {
  const VerifyOTP(this._repository);

  final AuthRepository _repository;

  ResultFuture<UserEntity> call({
    required String verificationId,
    required String smsCode,
  }) async {
    return _repository.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
