import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;

  const RegisterRequested(
    this.email,
    this.name,
    this.password,
    this.confirmPassword,
  );

  @override
  List<Object?> get props => [email, name, password, confirmPassword];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class TogglePasswordVisibility extends AuthEvent {}

class LocaleChanged extends AuthEvent {
  final String locale;

  const LocaleChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LogoutRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}
