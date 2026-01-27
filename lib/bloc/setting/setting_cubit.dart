import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/settings_repository.dart';
import 'package:money_mate/data/repository/user_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final SettingsRepository _settingsRepo;
  final UserRepository _userRepo;
  final TransactionRepository _transactionRepo;

  SettingCubit({
    required SettingsRepository settingsRepo,
    required UserRepository userRepo,
    required TransactionRepository transactionRepo,
  })  : _settingsRepo = settingsRepo,
        _userRepo = userRepo,
        _transactionRepo = transactionRepo,
        super(const SettingState()) {
    loadSettings();
    loadUserProfile();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      final isDark = await _settingsRepo.getDarkMode();
      final isLock = await _settingsRepo.getIsLock();
      final language = await _settingsRepo.getLanguage();

      emit(state.copyWith(
        status: SettingStatus.success,
        isDark: isDark ?? false,
        isLock: isLock ?? false,
        language: language ?? 'en',
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SettingStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final profile = await _userRepo.getUserProfile();
      emit(state.copyWith(
        userName: profile.email,
        // image: profile.image,
      ));
    } catch (e) {
      // Handle error quietly or update state
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    try {
      await _settingsRepo.updateDarkMode(value);
      emit(state.copyWith(isDark: value));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> toggleLock(bool value) async {
    try {
      await _settingsRepo.updateIsLock(value);
      emit(state.copyWith(isLock: value));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
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
