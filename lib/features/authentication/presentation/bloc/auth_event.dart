import 'package:equatable/equatable.dart';
import 'package:itspass_user/features/authentication/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithPhoneEvent extends AuthEvent {
  const SignInWithPhoneEvent({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOTPEvent extends AuthEvent {
  const VerifyOTPEvent({
    required this.verificationId,
    required this.smsCode,
  });

  final String verificationId;
  final String smsCode;

  @override
  List<Object> get props => [verificationId, smsCode];
}

class SaveUserDataEvent extends AuthEvent {
  const SaveUserDataEvent({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class GetUserDataEvent extends AuthEvent {
  const GetUserDataEvent();
}

class CheckUserExistsEvent extends AuthEvent {
  const CheckUserExistsEvent({this.email, this.phone});

  final String? email;
  final String? phone;

  @override
  List<Object?> get props => [email, phone];
}

class CheckUserBlockedEvent extends AuthEvent {
  const CheckUserBlockedEvent();
}

class CheckUserFieldsFilledEvent extends AuthEvent {
  const CheckUserFieldsFilledEvent();
}

class SignInWithGoogleEvent extends AuthEvent {
  const SignInWithGoogleEvent();
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}
