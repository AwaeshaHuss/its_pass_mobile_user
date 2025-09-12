import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uber_users_app/core/errors/exceptions.dart';
import 'package:uber_users_app/core/errors/failures.dart';
import 'package:uber_users_app/core/utils/typedef.dart';
import 'package:uber_users_app/features/authentication/data/datasources/auth_api_data_source.dart';
import 'package:uber_users_app/features/authentication/data/models/user_model.dart';
import 'package:uber_users_app/features/authentication/domain/entities/user_entity.dart';
import 'package:uber_users_app/features/authentication/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthApiDataSource _remoteDataSource;

  @override
  ResultVoid signInWithPhone({required String phoneNumber}) async {
    try {
      await _remoteDataSource.signInWithPhone(phoneNumber: phoneNumber);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOTP(
        phoneNumber: verificationId, // Using verificationId as phoneNumber for API
        otp: smsCode,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  ResultVoid saveUserData({required UserEntity user}) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _remoteDataSource.saveUserData(user: userModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> getUserData() async {
    try {
      final result = await _remoteDataSource.getUserData();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> checkUserExists({String? email, String? phone}) async {
    try {
      final result = await _remoteDataSource.checkUserExists(
        email: email,
        phone: phone,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> checkUserBlocked() async {
    try {
      final result = await _remoteDataSource.checkUserBlocked();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> checkUserFieldsFilled() async {
    try {
      final result = await _remoteDataSource.checkUserFieldsFilled();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> signInWithGoogle() async {
    try {
      final result = await _remoteDataSource.signInWithGoogle();
      return Right(result);
    } on ServerException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
