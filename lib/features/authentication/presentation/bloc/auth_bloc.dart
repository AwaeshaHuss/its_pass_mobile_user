import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:itspass_user/features/authentication/domain/usecases/get_user_data.dart';
import 'package:itspass_user/features/authentication/domain/usecases/save_user_data.dart';
import 'package:itspass_user/features/authentication/domain/usecases/sign_in_with_phone.dart';
import 'package:itspass_user/features/authentication/domain/usecases/verify_otp.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_event.dart';
import 'package:itspass_user/features/authentication/presentation/bloc/auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInWithPhone signInWithPhone,
    required VerifyOTP verifyOTP,
    required SaveUserData saveUserData,
    required GetUserData getUserData,
  })  : _signInWithPhone = signInWithPhone,
        _verifyOTP = verifyOTP,
        _saveUserData = saveUserData,
        _getUserData = getUserData,
        super(const AuthInitial()) {
    on<SignInWithPhoneEvent>(_onSignInWithPhone);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<SaveUserDataEvent>(_onSaveUserData);
    on<GetUserDataEvent>(_onGetUserData);
    on<SignOutEvent>(_onSignOut);
  }

  final SignInWithPhone _signInWithPhone;
  final VerifyOTP _verifyOTP;
  final SaveUserData _saveUserData;
  final GetUserData _getUserData;

  String? _verificationId;

  void _onSignInWithPhone(
    SignInWithPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await _signInWithPhone(phoneNumber: event.phoneNumber);

      result.fold(
        (failure) => emit(AuthError(message: 'Please check your phone number and try again')),
        (_) {
          // Generate a mock verification ID based on phone number for offline mode
          final mockVerificationId = 'mock_${event.phoneNumber.replaceAll('+', '').replaceAll(' ', '')}_${DateTime.now().millisecondsSinceEpoch}';
          _verificationId = mockVerificationId;
          emit(PhoneSignInSuccess(verificationId: mockVerificationId));
        },
      );
    } catch (e) {
      // Handle any unexpected errors gracefully
      emit(const AuthError(message: 'Authentication service temporarily unavailable. Please try again.'));
    }
  }

  void _onVerifyOTP(
    VerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await _verifyOTP(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );

      result.fold(
        (failure) => emit(const AuthError(message: 'Invalid OTP. Please try again.')),
        (user) {
          _verificationId = null;
          emit(OTPVerificationSuccess(user: user));
          emit(Authenticated(user: user));
        },
      );
    } catch (e) {
      // Handle any unexpected errors gracefully
      emit(const AuthError(message: 'Verification failed. Please try again.'));
    }
  }

  void _onSaveUserData(
    SaveUserDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _saveUserData(user: event.user);

    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (_) {
        emit(const UserDataSaved());
        emit(Authenticated(user: event.user));
      },
    );
  }

  void _onGetUserData(
    GetUserDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await _getUserData();

      result.fold(
        (failure) => emit(const AuthError(message: 'Unable to load user data. Please try again.')),
        (user) {
          emit(UserDataLoaded(user: user));
          emit(Authenticated(user: user));
        },
      );
    } catch (e) {
      // Handle any unexpected errors gracefully
      emit(const AuthError(message: 'Data loading failed. Please try again.'));
    }
  }

  void _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // For now, just emit sign out success
    // In a real implementation, you'd call a sign out use case
    emit(const SignOutSuccess());
    emit(const Unauthenticated());
  }

  // Helper method to set verification ID from external sources
  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
  }

  String? get verificationId => _verificationId;
}
