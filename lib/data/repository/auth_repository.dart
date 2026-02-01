import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

abstract class AuthRepository {
  Future<AuthResponseDto> login(String email, String password);
  Future<AuthResponseDto> register(
    String email,
    String name,
    String password,
    String confirmPassword, {
    String? language,
  });
  Future<void> logout();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<void> forgotPassword(String email);
  Future<AuthResponseDto> refresh();
  Future<String?> getAccessToken();
}

class AuthRepositoryImpl implements AuthRepository {
  final _api = ApiClient.api;
  final _storage = const FlutterSecureStorage();

  @override
  Future<AuthResponseDto> login(String email, String password) async {
    final response = await _api.apiAuthLoginPost(
      body: LoginDto(email: email, password: password),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Login failed');
    }
  }

  @override
  Future<AuthResponseDto> register(
    String email,
    String name,
    String password,
    String confirmPassword, {
    String? language,
  }) async {
    final response = await _api.apiAuthRegisterPost(
      body: RegisterDto(
        email: email,
        name: name,
        password: password,
        confirmPassword: confirmPassword,
        language: language,
      ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Registration failed');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _api.apiAuthLogoutPost();
    } catch (_) {
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
    final response = await _api.apiAuthForgotPasswordPost(
      body: ForgotPasswordDto(email: email),
    );

    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Forgot password failed');
    }
  }

  @override
  Future<AuthResponseDto> refresh() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    final response = await _api.apiAuthRefreshPost(
      body: RefreshTokenDto(refreshToken: refreshToken),
    );

    if (response.isSuccessful && response.body != null) {
      await saveTokens(response.body!.accessToken, response.body!.refreshToken);
      return response.body!;
    } else {
      await _storage.deleteAll();
      throw Exception(response.error ?? 'Token refresh failed');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }
}
