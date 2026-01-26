import 'package:dio/dio.dart';
import 'package:money_mate/data/network/dio_client.dart';

abstract class UserRepository {
  Future<Map<String, dynamic>> getUserProfile();
  Future<void> updateLanguage(String language);
  Future<void> updateDarkMode(bool isDark);
  Future<void> deleteAccount();
}

class UserRepositoryImpl implements UserRepository {
  final Dio _dio = DioClient().dio;

  @override
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return response.data;
    } catch (e) {
      rethrow;
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
  Future<void> updateDarkMode(bool isDark) async {
    try {
      await _dio.patch('/users/me/settings', data: {'isDark': isDark});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete('/users/me');
    } catch (e) {
      rethrow;
    }
  }
}
