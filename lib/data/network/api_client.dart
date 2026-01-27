import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

class ApiClient {
  static late MoneyMateApi _api;

  static void init({required String baseUrl}) {
    final client = ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      services: [MoneyMateApi.create()],
      converter: $JsonSerializableConverter(),
      interceptors: [_AuthInterceptor(), HttpLoggingInterceptor()],
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
    if (token != null) {
      final newRequest = request.copyWith(
        headers: {...request.headers, 'Authorization': 'Bearer $token'},
      );
      return chain.proceed(newRequest);
    }
    return chain.proceed(request);
  }
}
