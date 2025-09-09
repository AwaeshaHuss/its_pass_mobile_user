import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uber_users_app/core/errors/failures.dart';
import 'package:uber_users_app/features/authentication/domain/entities/user_entity.dart';
import 'package:uber_users_app/features/authentication/domain/usecases/get_user_data.dart';
import 'package:uber_users_app/features/authentication/domain/usecases/save_user_data.dart';
import 'package:uber_users_app/features/authentication/domain/usecases/sign_in_with_phone.dart';
import 'package:uber_users_app/features/authentication/domain/usecases/verify_otp.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:uber_users_app/features/authentication/presentation/bloc/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  SignInWithPhone,
  VerifyOTP,
  SaveUserData,
  GetUserData,
])
void main() {
  late AuthBloc authBloc;
  late MockSignInWithPhone mockSignInWithPhone;
  late MockVerifyOTP mockVerifyOTP;
  late MockSaveUserData mockSaveUserData;
  late MockGetUserData mockGetUserData;

  const testUser = UserEntity(
    id: 'test_id',
    name: 'Test User',
    email: 'test@example.com',
    phone: '+1234567890',
    blockStatus: 'no',
  );

  setUp(() {
    mockSignInWithPhone = MockSignInWithPhone();
    mockVerifyOTP = MockVerifyOTP();
    mockSaveUserData = MockSaveUserData();
    mockGetUserData = MockGetUserData();

    authBloc = AuthBloc(
      signInWithPhone: mockSignInWithPhone,
      verifyOTP: mockVerifyOTP,
      saveUserData: mockSaveUserData,
      getUserData: mockGetUserData,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(const AuthInitial()));
    });

    group('SignInWithPhoneEvent', () {
      const phoneNumber = '+1234567890';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, PhoneSignInSuccess] when sign in is successful',
        build: () {
          when(mockSignInWithPhone(phoneNumber: phoneNumber))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignInWithPhoneEvent(phoneNumber: phoneNumber)),
        expect: () => [
          const AuthLoading(),
          const PhoneSignInSuccess(verificationId: 'temp_verification_id'),
        ],
        verify: (_) {
          verify(mockSignInWithPhone(phoneNumber: phoneNumber)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign in fails',
        build: () {
          when(mockSignInWithPhone(phoneNumber: phoneNumber))
              .thenAnswer((_) async => const Left(ServerFailure('Sign in failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignInWithPhoneEvent(phoneNumber: phoneNumber)),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Instance of \'ServerFailure\''),
        ],
        verify: (_) {
          verify(mockSignInWithPhone(phoneNumber: phoneNumber)).called(1);
        },
      );
    });

    group('VerifyOTPEvent', () {
      const verificationId = 'test_verification_id';
      const smsCode = '123456';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, OTPVerificationSuccess, Authenticated] when OTP verification is successful',
        build: () {
          when(mockVerifyOTP(verificationId: verificationId, smsCode: smsCode))
              .thenAnswer((_) async => const Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const VerifyOTPEvent(
          verificationId: verificationId,
          smsCode: smsCode,
        )),
        expect: () => [
          const AuthLoading(),
          const OTPVerificationSuccess(user: testUser),
          const Authenticated(user: testUser),
        ],
        verify: (_) {
          verify(mockVerifyOTP(verificationId: verificationId, smsCode: smsCode))
              .called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when OTP verification fails',
        build: () {
          when(mockVerifyOTP(verificationId: verificationId, smsCode: smsCode))
              .thenAnswer((_) async => const Left(AuthenticationFailure('Invalid OTP')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const VerifyOTPEvent(
          verificationId: verificationId,
          smsCode: smsCode,
        )),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Instance of \'AuthenticationFailure\''),
        ],
        verify: (_) {
          verify(mockVerifyOTP(verificationId: verificationId, smsCode: smsCode))
              .called(1);
        },
      );
    });

    group('SaveUserDataEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, UserDataSaved, Authenticated] when save user data is successful',
        build: () {
          when(mockSaveUserData(user: testUser))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SaveUserDataEvent(user: testUser)),
        expect: () => [
          const AuthLoading(),
          const UserDataSaved(),
          const Authenticated(user: testUser),
        ],
        verify: (_) {
          verify(mockSaveUserData(user: testUser)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when save user data fails',
        build: () {
          when(mockSaveUserData(user: testUser))
              .thenAnswer((_) async => const Left(ServerFailure('Save failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SaveUserDataEvent(user: testUser)),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Instance of \'ServerFailure\''),
        ],
        verify: (_) {
          verify(mockSaveUserData(user: testUser)).called(1);
        },
      );
    });

    group('GetUserDataEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, UserDataLoaded, Authenticated] when get user data is successful',
        build: () {
          when(mockGetUserData())
              .thenAnswer((_) async => const Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const GetUserDataEvent()),
        expect: () => [
          const AuthLoading(),
          const UserDataLoaded(user: testUser),
          const Authenticated(user: testUser),
        ],
        verify: (_) {
          verify(mockGetUserData()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when get user data fails',
        build: () {
          when(mockGetUserData())
              .thenAnswer((_) async => const Left(ServerFailure('Get user data failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const GetUserDataEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Instance of \'ServerFailure\''),
        ],
        verify: (_) {
          verify(mockGetUserData()).called(1);
        },
      );
    });

    group('SignOutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, SignOutSuccess, Unauthenticated] when sign out is triggered',
        build: () => authBloc,
        act: (bloc) => bloc.add(const SignOutEvent()),
        expect: () => [
          const AuthLoading(),
          const SignOutSuccess(),
          const Unauthenticated(),
        ],
      );
    });
  });
}
