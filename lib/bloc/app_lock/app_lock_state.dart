import 'package:equatable/equatable.dart';

enum AppLockStatus { initial, authenticating, authorized, unauthorized }

class AppLockState extends Equatable {
  final AppLockStatus status;
  final bool isAuthorized;
  final bool isAuthenticating;

  const AppLockState({
    this.status = AppLockStatus.initial,
    this.isAuthorized = false,
    this.isAuthenticating = false,
  });

  AppLockState copyWith({
    AppLockStatus? status,
    bool? isAuthorized,
    bool? isAuthenticating,
  }) {
    return AppLockState(
      status: status ?? this.status,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
    );
  }

  @override
  List<Object?> get props => [status, isAuthorized, isAuthenticating];
}
