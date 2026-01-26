import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/auth_repository.dart';
import 'package:money_mate/bloc/auth/auth_event.dart';
import 'package:money_mate/bloc/auth/auth_state.dart';
import 'package:flutter_localization/flutter_localization.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  AuthBloc({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(AuthState(
          currentLocale:
              FlutterLocalization.instance.currentLocale?.languageCode ?? 'en',
        )) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<LocaleChanged>(_onLocaleChanged);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepo.logout();
    emit(state.copyWith(status: AuthStatus.initial));
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authRepo.login(event.email, event.password);
      await _authRepo.saveTokens(
        response['accessToken'],
        response['refreshToken'] ?? '',
      );
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepo.register(
          event.email, event.password, event.confirmPassword);
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepo.forgotPassword(event.email);
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(isShow: !state.isShow));
  }

  void _onLocaleChanged(LocaleChanged event, Emitter<AuthState> emit) {
    _localization.translate(event.locale);
    emit(state.copyWith(currentLocale: event.locale));
  }
}
