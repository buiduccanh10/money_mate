import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_mate/bloc/auth/auth_bloc.dart';
import 'package:money_mate/bloc/auth/auth_state.dart';
import 'package:money_mate/data/repository/settings_repository.dart';
import 'package:money_mate/data/repository/user_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final SettingsRepository _settingsRepo;
  final UserRepository _userRepo;
  final TransactionRepository _transactionRepo;
  final AuthBloc? _authBloc;
  StreamSubscription<AuthState>? _authSubscription;

  SettingCubit({
    required SettingsRepository settingsRepo,
    required UserRepository userRepo,
    required TransactionRepository transactionRepo,
    AuthBloc? authBloc,
  }) : _settingsRepo = settingsRepo,
       _userRepo = userRepo,
       _transactionRepo = transactionRepo,
       _authBloc = authBloc,
       super(const SettingState()) {
    loadSettings();

    _authSubscription = _authBloc?.stream.listen((authState) {
      if (authState.status == AuthStatus.success) {
        loadUserProfile();
      }
    });

    if (_authBloc?.state.status == AuthStatus.success) {
      loadUserProfile();
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      final isDark = await _settingsRepo.getDarkMode();
      final isLock = await _settingsRepo.getIsLock();
      final language = await _settingsRepo.getLanguage();

      emit(
        state.copyWith(
          status: SettingStatus.success,
          isDark: isDark ?? false,
          isLock: isLock ?? false,
          language:
              [
                'vi',
                'zh',
              ].contains(PlatformDispatcher.instance.locale.languageCode)
              ? PlatformDispatcher.instance.locale.languageCode
              : (language ?? 'en'),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final profile = await _userRepo.getUserProfile();
      emit(
        state.copyWith(
          userName: profile.name ?? profile.email,
          email: profile.email,
          image: profile.avatar,
          language: profile.language,
          isDark: profile.isDark,
          isLock: profile.isLock,
        ),
      );

      await _settingsRepo.updateLanguage(profile.language);
      await _settingsRepo.updateDarkMode(profile.isDark);
      await _settingsRepo.updateIsLock(profile.isLock);
    } catch (e) {
      // Handle error quietly or update state
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    final oldState = state.isDark;
    emit(state.copyWith(isDark: value));
    try {
      await _settingsRepo.updateDarkMode(value);
    } catch (e) {
      emit(state.copyWith(isDark: oldState, errorMessage: e.toString()));
    }
  }

  Future<void> toggleLock(
    bool value, {
    required String reason,
    String? notSupportError,
  }) async {
    final LocalAuthentication auth = LocalAuthentication();

    if (value) {
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        emit(
          state.copyWith(
            errorMessage: notSupportError ?? 'Device security not supported',
          ),
        );
        return;
      }
    }

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: reason,
      );

      if (didAuthenticate) {
        final oldState = state.isLock;
        emit(state.copyWith(isLock: value, errorMessage: null));
        try {
          await _settingsRepo.updateIsLock(value);
        } catch (e) {
          emit(state.copyWith(isLock: oldState, errorMessage: e.toString()));
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> setLanguage(String lang) async {
    try {
      await _settingsRepo.updateLanguage(lang);
      emit(state.copyWith(language: lang));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> changeLanguage(String lang) => setLanguage(lang);

  void updateLanguageLocale(String lang) {
    emit(state.copyWith(language: lang));
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? password,
    File? imageFile,
    String? avatar,
  }) async {
    try {
      var currentUser = await _userRepo.getUserProfile();

      if (imageFile != null) {
        currentUser = await _userRepo.updateAvatar(imageFile);
      }

      if (name != null || email != null || password != null || avatar != null) {
        currentUser = await _userRepo.updateProfile(
          name: name ?? currentUser.name,
          email: email ?? currentUser.email,
          password: password,
          avatar: avatar ?? currentUser.avatar,
        );
      }

      emit(
        state.copyWith(
          userName: currentUser.name ?? currentUser.email,
          email: currentUser.email,
          image: currentUser.avatar,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteAllData() async {
    try {
      await _transactionRepo.deleteAllTransactions();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      await _userRepo.deleteAccount();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
