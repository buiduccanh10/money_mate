import 'package:dio/dio.dart';
import 'package:money_mate/data/network/dio_client.dart';

abstract class SettingsRepository {
  Future<String?> getLanguage();
  Future<void> updateLanguage(String language);
  Future<bool?> getDarkMode();
  Future<void> updateDarkMode(bool isDark);
  Future<bool?> getIsLock();
  Future<void> updateIsLock(bool isLock);
  Future<void> deleteUser();
  Future<void> deleteAllData();
  Future<int> scheduleInputTask(String date, String description, double money,
      String catId, String icon, String name, bool isIncome, String option);
  Future<void> removeScheduleTask(int id);
  Future<void> removeAllSchedule();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final Dio _dio = DioClient().dio;

  @override
  Future<String?> getLanguage() async {
    try {
      final response = await _dio.get('/users/me/settings');
      return response.data['language'] ?? 'en';
    } catch (e) {
      return 'en';
    }
  }

  @override
  Future<void> updateLanguage(String language) async {
    try {
      await _dio.patch('/users/me/settings', data: {'language': language});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool?> getDarkMode() async {
    try {
      final response = await _dio.get('/users/me/settings');
      return response.data['isDark'] ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateDarkMode(bool isDark) async {
    try {
      await _dio.patch('/users/me/settings', data: {'isDark': isDark});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool?> getIsLock() async {
    try {
      final response = await _dio.get('/users/me/settings');
      return response.data['isLock'] ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateIsLock(bool isLock) async {
    try {
      await _dio.patch('/users/me/settings', data: {'isLock': isLock});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _dio.delete('/users/me');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllData() async {
    try {
      await _dio.delete('/transactions');
      await _dio.delete('/categories');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> scheduleInputTask(
      String date,
      String description,
      double money,
      String catId,
      String icon,
      String name,
      bool isIncome,
      String option) async {
    try {
      final response = await _dio.post('/schedules', data: {
        'date': date,
        'description': description,
        'money': money,
        'catId': catId,
        'icon': icon,
        'name': name,
        'isIncome': isIncome,
        'option': option,
      });
      return response.data['id'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeScheduleTask(int id) async {
    try {
      await _dio.delete('/schedules/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeAllSchedule() async {
    try {
      await _dio.delete('/schedules');
    } catch (e) {
      rethrow;
    }
  }
}
