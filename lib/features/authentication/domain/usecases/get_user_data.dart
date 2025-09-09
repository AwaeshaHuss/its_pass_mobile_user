import 'package:injectable/injectable.dart';
import 'package:uber_users_app/core/utils/typedef.dart';
import 'package:uber_users_app/features/authentication/domain/entities/user_entity.dart';
import 'package:uber_users_app/features/authentication/domain/repositories/auth_repository.dart';

@lazySingleton
class GetUserData {
  const GetUserData(this._repository);

  final AuthRepository _repository;

  ResultFuture<UserEntity> call() async {
    return _repository.getUserData();
  }
}
