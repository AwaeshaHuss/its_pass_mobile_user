// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:itspass_user/core/network/api_client.dart' as _i634;
import 'package:itspass_user/core/network/api_service.dart' as _i555;
import 'package:itspass_user/features/authentication/data/datasources/auth_api_data_source.dart'
    as _i951;
import 'package:itspass_user/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i664;
import 'package:itspass_user/features/authentication/domain/repositories/auth_repository.dart'
    as _i986;
import 'package:itspass_user/features/authentication/domain/usecases/get_user_data.dart'
    as _i771;
import 'package:itspass_user/features/authentication/domain/usecases/save_user_data.dart'
    as _i803;
import 'package:itspass_user/features/authentication/domain/usecases/sign_in_with_phone.dart'
    as _i598;
import 'package:itspass_user/features/authentication/domain/usecases/verify_otp.dart'
    as _i553;
import 'package:itspass_user/features/authentication/presentation/bloc/auth_bloc.dart'
    as _i94;
import 'package:itspass_user/injection/app_module.dart' as _i285;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i116.GoogleSignIn>(() => appModule.googleSignIn);
    gh.lazySingleton<_i634.ApiClient>(
        () => _i634.ApiClient(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i555.ApiService>(
        () => _i555.ApiService(gh<_i634.ApiClient>()));
    gh.lazySingleton<_i951.AuthApiDataSource>(() => _i951.AuthApiDataSourceImpl(
          googleSignIn: gh<_i116.GoogleSignIn>(),
          sharedPreferences: gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i986.AuthRepository>(
        () => _i664.AuthRepositoryImpl(gh<_i951.AuthApiDataSource>()));
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

class _$AppModule extends _i285.AppModule {}
