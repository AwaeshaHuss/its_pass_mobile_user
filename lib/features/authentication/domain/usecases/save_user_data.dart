import 'package:injectable/injectable.dart';
import 'package:uber_users_app/core/utils/typedef.dart';
import 'package:uber_users_app/features/authentication/domain/entities/user_entity.dart';
import 'package:uber_users_app/features/authentication/domain/repositories/auth_repository.dart';

@lazySingleton
class SaveUserData {
  const SaveUserData(this._repository);

  final AuthRepository _repository;

  ResultVoid call({required UserEntity user}) async {
    return _repository.saveUserData(user: user);
  }
}
