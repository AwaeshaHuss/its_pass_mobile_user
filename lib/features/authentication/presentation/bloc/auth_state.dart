import 'package:equatable/equatable.dart';
import 'package:uber_users_app/features/authentication/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

// Phone Sign-in States
class PhoneSignInSuccess extends AuthState {
  const PhoneSignInSuccess({required this.verificationId});

  final String verificationId;

  @override
  List<Object> get props => [verificationId];
}

// OTP Verification States
class OTPVerificationSuccess extends AuthState {
  const OTPVerificationSuccess({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

// User Data States
class UserDataSaved extends AuthState {
  const UserDataSaved();
}

class UserDataLoaded extends AuthState {
  const UserDataLoaded({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

// User Check States
class UserExistsResult extends AuthState {
  const UserExistsResult({required this.exists});

  final bool exists;

  @override
  List<Object> get props => [exists];
}

class UserBlockedResult extends AuthState {
  const UserBlockedResult({required this.isBlocked});

  final bool isBlocked;

  @override
  List<Object> get props => [isBlocked];
}

class UserFieldsFilledResult extends AuthState {
  const UserFieldsFilledResult({required this.isFilled});

  final bool isFilled;

  @override
  List<Object> get props => [isFilled];
}

// Google Sign-in States
class GoogleSignInSuccess extends AuthState {
  const GoogleSignInSuccess({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

// Sign Out States
class SignOutSuccess extends AuthState {
  const SignOutSuccess();
}

// Authentication Status States
class Authenticated extends AuthState {
  const Authenticated({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}
