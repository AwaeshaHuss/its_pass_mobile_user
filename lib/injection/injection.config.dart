// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_database/firebase_database.dart' as _i345;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uber_users_app/features/authentication/data/datasources/auth_remote_data_source.dart'
    as _i467;
import 'package:uber_users_app/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i664;
import 'package:uber_users_app/features/authentication/domain/repositories/auth_repository.dart'
    as _i986;
import 'package:uber_users_app/features/authentication/domain/usecases/get_user_data.dart'
    as _i771;
import 'package:uber_users_app/features/authentication/domain/usecases/save_user_data.dart'
    as _i803;
import 'package:uber_users_app/features/authentication/domain/usecases/sign_in_with_phone.dart'
    as _i598;
import 'package:uber_users_app/features/authentication/domain/usecases/verify_otp.dart'
    as _i553;
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_bloc.dart'
    as _i94;
import 'package:uber_users_app/injection/firebase_module.dart' as _i859;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i345.FirebaseDatabase>(
        () => firebaseModule.firebaseDatabase);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i467.AuthRemoteDataSource>(
        () => _i467.AuthRemoteDataSourceImpl(
              firebaseAuth: gh<_i59.FirebaseAuth>(),
              firebaseDatabase: gh<_i345.FirebaseDatabase>(),
              googleSignIn: gh<_i116.GoogleSignIn>(),
            ));
    gh.lazySingleton<_i986.AuthRepository>(
        () => _i664.AuthRepositoryImpl(gh<_i467.AuthRemoteDataSource>()));
    gh.lazySingleton<_i553.VerifyOTP>(
        () => _i553.VerifyOTP(gh<_i986.AuthRepository>()));
    gh.lazySingleton<_i598.SignInWithPhone>(
        () => _i598.SignInWithPhone(gh<_i986.AuthRepository>()));
    gh.lazySingleton<_i803.SaveUserData>(
        () => _i803.SaveUserData(gh<_i986.AuthRepository>()));
    gh.lazySingleton<_i771.GetUserData>(
        () => _i771.GetUserData(gh<_i986.AuthRepository>()));
    gh.factory<_i94.AuthBloc>(() => _i94.AuthBloc(
          signInWithPhone: gh<_i598.SignInWithPhone>(),
          verifyOTP: gh<_i553.VerifyOTP>(),
          saveUserData: gh<_i803.SaveUserData>(),
          getUserData: gh<_i771.GetUserData>(),
        ));
    return this;
  }
}

class _$FirebaseModule extends _i859.FirebaseModule {}
