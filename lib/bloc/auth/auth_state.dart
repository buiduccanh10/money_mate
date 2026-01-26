import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final bool isShow;
  final String currentLocale;
  final String? email;
  final String? image;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.isShow = true,
    this.currentLocale = 'en',
    this.email,
    this.image,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? isShow,
    String? currentLocale,
    String? email,
    String? image,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isShow: isShow ?? this.isShow,
      currentLocale: currentLocale ?? this.currentLocale,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, isShow, currentLocale, email, image];
}
