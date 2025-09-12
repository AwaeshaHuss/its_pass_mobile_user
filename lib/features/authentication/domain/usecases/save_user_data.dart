import 'package:injectable/injectable.dart';
import 'package:itspass_user/core/utils/typedef.dart';
import 'package:itspass_user/features/authentication/domain/entities/user_entity.dart';
import 'package:itspass_user/features/authentication/domain/repositories/auth_repository.dart';

@lazySingleton
class SaveUserData {
  const SaveUserData(this._repository);

  final AuthRepository _repository;

  ResultVoid call({required UserEntity user}) async {
    return _repository.saveUserData(user: user);
  }
}
