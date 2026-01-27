import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

abstract class SettingsRepository {
  Future<String?> getLanguage();
  Future<void> updateLanguage(String language);
  Future<bool?> getDarkMode();
  Future<void> updateDarkMode(bool isDark);
  Future<bool?> getIsLock();
  Future<void> updateIsLock(bool isLock);
  Future<void> deleteUser();
  Future<void> deleteAllData();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final _api = ApiClient.api;

  @override
  Future<String?> getLanguage() async {
    try {
      final response = await _api.apiUsersMeSettingsGet();
      if (response.isSuccessful && response.body != null) {
        return response.body!.language;
      }
      return 'en';
    } catch (e) {
      return 'en';
    }
  }

  @override
  Future<void> updateLanguage(String language) async {
    final response = await _api.apiUsersMeSettingsPatch(
      body: UpdateSettingsDto(language: language),
    );
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to update language');
    }
  }

  @override
  Future<bool?> getDarkMode() async {
    try {
      final response = await _api.apiUsersMeSettingsGet();
      if (response.isSuccessful && response.body != null) {
        return response.body!.isDark;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateDarkMode(bool isDark) async {
    final response = await _api.apiUsersMeSettingsPatch(
      body: UpdateSettingsDto(isDark: isDark),
    );
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to update dark mode');
    }
  }

  @override
  Future<bool?> getIsLock() async {
    try {
      final response = await _api.apiUsersMeSettingsGet();
      if (response.isSuccessful && response.body != null) {
        return response.body!.isLock;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateIsLock(bool isLock) async {
    final response = await _api.apiUsersMeSettingsPatch(
      body: UpdateSettingsDto(isLock: isLock),
    );
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to update lock');
    }
  }

  @override
  Future<void> deleteUser() async {
    final response = await _api.apiUsersMeDelete();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete user');
    }
  }

  @override
  Future<void> deleteAllData() async {
    final response = await _api.apiTransactionsDelete();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete all data');
    }
  }
}
