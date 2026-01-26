import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_mate/data/network/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add Access Token to header
          final accessToken = await _storage.read(key: 'accessToken');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired, try to refresh
            final refreshToken = await _storage.read(key: 'refreshToken');
            if (refreshToken != null) {
              if (await _refreshToken(refreshToken)) {
                // Retry the original request
                final opts = e.requestOptions;
                final newAccessToken = await _storage.read(key: 'accessToken');
                opts.headers['Authorization'] = 'Bearer $newAccessToken';

                try {
                  final cloneReq = await _dio.fetch(opts);
                  return handler.resolve(cloneReq);
                } catch (e) {
                  return handler.next(e as DioException);
                }
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response
            .data['refreshToken']; // Optional: if API rotates refresh tokens

        await _storage.write(key: 'accessToken', value: newAccessToken);
        if (newRefreshToken != null) {
          await _storage.write(key: 'refreshToken', value: newRefreshToken);
        }
        return true;
      }
    } catch (e) {
      // Refresh failed, maybe logout user
      await _storage.deleteAll();
      return false;
    }
    return false;
  }
}
