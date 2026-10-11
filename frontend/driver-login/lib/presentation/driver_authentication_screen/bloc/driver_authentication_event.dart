part of 'driver_authentication_bloc.dart';

abstract class DriverAuthenticationEvent extends Equatable {
  const DriverAuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class DriverAuthenticationInitialEvent extends DriverAuthenticationEvent {}

class ChangeEmailEvent extends DriverAuthenticationEvent {
  final String email;

  const ChangeEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ChangePasswordEvent extends DriverAuthenticationEvent {
  final String password;

  const ChangePasswordEvent(this.password);

  @override
  List<Object> get props => [password];
}

class LoginButtonPressedEvent extends DriverAuthenticationEvent {}

class SignUpButtonPressedEvent extends DriverAuthenticationEvent {}
