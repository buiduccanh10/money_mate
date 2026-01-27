import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

abstract class UserRepository {
  Future<UserResponseDto> getUserProfile();
  Future<UserSettingsResponseDto> updateLanguage(String language);
  Future<UserSettingsResponseDto> updateDarkMode(bool isDark);
  Future<void> deleteAccount();
}

class UserRepositoryImpl implements UserRepository {
  final _api = ApiClient.api;

  @override
  Future<UserResponseDto> getUserProfile() async {
    final response = await _api.apiUsersMeGet();
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to fetch user profile');
    }
  }

  @override
  Future<UserSettingsResponseDto> updateLanguage(String language) async {
    final response = await _api.apiUsersMeSettingsPatch(
      body: UpdateSettingsDto(language: language),
    );
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to update language');
    }
  }

  @override
  Future<UserSettingsResponseDto> updateDarkMode(bool isDark) async {
    final response = await _api.apiUsersMeSettingsPatch(
      body: UpdateSettingsDto(isDark: isDark),
    );
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to update dark mode');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _api.apiUsersMeDelete();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete account');
    }
  }
}
