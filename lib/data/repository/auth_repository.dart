import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_mate/data/network/api_constants.dart';
import 'package:money_mate/data/network/dio_client.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String email, String password,
      String confirmPassword); // Adjusted signature
  Future<void> logout();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<void> forgotPassword(String email);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = DioClient().dio;
  final _storage = const FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String email, String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logoutEndpoint);
    } catch (e) {
      // Ignore errors on logout
    } finally {
      await _storage.deleteAll();
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio
          .post(ApiConstants.forgotPasswordEndpoint, data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }
}
