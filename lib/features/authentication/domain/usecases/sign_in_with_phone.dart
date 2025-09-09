import 'package:injectable/injectable.dart';
import 'package:uber_users_app/core/utils/typedef.dart';
import 'package:uber_users_app/features/authentication/domain/repositories/auth_repository.dart';

@lazySingleton
class SignInWithPhone {
  const SignInWithPhone(this._repository);

  final AuthRepository _repository;

  ResultVoid call({required String phoneNumber}) async {
    return _repository.signInWithPhone(phoneNumber: phoneNumber);
  }
}
