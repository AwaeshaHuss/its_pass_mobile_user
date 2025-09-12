import 'package:injectable/injectable.dart';
import 'package:itspass_user/core/utils/typedef.dart';
import 'package:itspass_user/features/authentication/domain/repositories/auth_repository.dart';

@lazySingleton
class SignInWithPhone {
  const SignInWithPhone(this._repository);

  final AuthRepository _repository;

  ResultVoid call({required String phoneNumber}) async {
    return _repository.signInWithPhone(phoneNumber: phoneNumber);
  }
}
