import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

class ApiClient {
  static late MoneyMateApi _api;
  static late Uri _baseUri;

  static void init({required String baseUrl}) {
    _baseUri = Uri.parse(baseUrl);
    final client = ChopperClient(
      baseUrl: _baseUri,
      services: [MoneyMateApi.create()],
      converter: $JsonSerializableConverter(),
      interceptors: [_AuthInterceptor(), HttpLoggingInterceptor()],
      authenticator: _AppAuthenticator(),
    );
    _api = MoneyMateApi.create(client: client);
  }

  static MoneyMateApi get api => _api;
}

class _AuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken');
    final request = chain.request;

    if (token != null && !request.headers.containsKey('Authorization')) {
      final newRequest = request.copyWith(
        headers: {...request.headers, 'Authorization': 'Bearer $token'},
      );
      return chain.proceed(newRequest);
    }
    return chain.proceed(request);
  }
}

class _AppAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode == 401) {
      final storage = const FlutterSecureStorage();
      final refreshToken = await storage.read(key: 'refreshToken');

      if (refreshToken != null) {
        try {
          // Create a temporary client to avoid circular dependency
          final refreshClient = ChopperClient(
            baseUrl: ApiClient._baseUri,
            services: [MoneyMateApi.create()],
            converter: $JsonSerializableConverter(),
          );
          final api = MoneyMateApi.create(client: refreshClient);

          final refreshResponse = await api.apiAuthRefreshPost(
            body: RefreshTokenDto(refreshToken: refreshToken),
          );

          if (refreshResponse.isSuccessful && refreshResponse.body != null) {
            final newAccessToken = refreshResponse.body!.accessToken;
            final newRefreshToken = refreshResponse.body!.refreshToken;

            await storage.write(key: 'accessToken', value: newAccessToken);
            await storage.write(key: 'refreshToken', value: newRefreshToken);

            return request.copyWith(
              headers: {
                ...request.headers,
                'Authorization': 'Bearer $newAccessToken',
              },
            );
          }
        } catch (_) {
          // Refresh failed
        }
      }
      // If refresh fails or no token, logout (clear storage)
      await storage.deleteAll();
    }
    return null;
  }
}
