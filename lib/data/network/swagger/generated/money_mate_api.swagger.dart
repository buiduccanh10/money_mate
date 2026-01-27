// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'money_mate_api.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'money_mate_api.enums.swagger.dart' as enums;
import 'money_mate_api.metadata.swagger.dart';
export 'money_mate_api.enums.swagger.dart';
export 'money_mate_api.models.swagger.dart';

part 'money_mate_api.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class MoneyMateApi extends ChopperService {
  static MoneyMateApi create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$MoneyMateApi(client);
    }

    final newClient = ChopperClient(
      services: [_$MoneyMateApi()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$MoneyMateApi(newClient);
  }

  ///Register a new user
  Future<chopper.Response<AuthResponseDto>> apiAuthRegisterPost({
    required RegisterDto? body,
  }) {
    generatedMapping.putIfAbsent(
      AuthResponseDto,
      () => AuthResponseDto.fromJsonFactory,
    );

    return _apiAuthRegisterPost(body: body);
  }

  ///Register a new user
  @POST(path: '/api/auth/register', optionalBody: true)
  Future<chopper.Response<AuthResponseDto>> _apiAuthRegisterPost({
    @Body() required RegisterDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Register a new user',
      operationId: 'AuthController_register',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authentication"],
      deprecated: false,
    ),
  });

  ///Login with email and password
  Future<chopper.Response<AuthResponseDto>> apiAuthLoginPost({
    required LoginDto? body,
  }) {
    generatedMapping.putIfAbsent(
      AuthResponseDto,
      () => AuthResponseDto.fromJsonFactory,
    );

    return _apiAuthLoginPost(body: body);
  }

  ///Login with email and password
  @POST(path: '/api/auth/login', optionalBody: true)
  Future<chopper.Response<AuthResponseDto>> _apiAuthLoginPost({
    @Body() required LoginDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Login with email and password',
      operationId: 'AuthController_login',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authentication"],
      deprecated: false,
    ),
  });

  ///Refresh access token
  Future<chopper.Response<AuthResponseDto>> apiAuthRefreshPost({
    required RefreshTokenDto? body,
  }) {
    generatedMapping.putIfAbsent(
      AuthResponseDto,
      () => AuthResponseDto.fromJsonFactory,
    );

    return _apiAuthRefreshPost(body: body);
  }

  ///Refresh access token
  @POST(path: '/api/auth/refresh', optionalBody: true)
  Future<chopper.Response<AuthResponseDto>> _apiAuthRefreshPost({
    @Body() required RefreshTokenDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Refresh access token',
      operationId: 'AuthController_refresh',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authentication"],
      deprecated: false,
    ),
  });

  ///Logout user
  Future<chopper.Response<LogoutResponseDto>> apiAuthLogoutPost() {
    generatedMapping.putIfAbsent(
      LogoutResponseDto,
      () => LogoutResponseDto.fromJsonFactory,
    );

    return _apiAuthLogoutPost();
  }

  ///Logout user
  @POST(path: '/api/auth/logout', optionalBody: true)
  Future<chopper.Response<LogoutResponseDto>> _apiAuthLogoutPost({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Logout user',
      operationId: 'AuthController_logout',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Authentication"],
      deprecated: false,
    ),
  });

  ///Send password reset email
  Future<chopper.Response<ForgotPasswordResponseDto>>
  apiAuthForgotPasswordPost({required ForgotPasswordDto? body}) {
    generatedMapping.putIfAbsent(
      ForgotPasswordResponseDto,
      () => ForgotPasswordResponseDto.fromJsonFactory,
    );

    return _apiAuthForgotPasswordPost(body: body);
  }

  ///Send password reset email
  @POST(path: '/api/auth/forgot-password', optionalBody: true)
  Future<chopper.Response<ForgotPasswordResponseDto>>
  _apiAuthForgotPasswordPost({
    @Body() required ForgotPasswordDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Send password reset email',
      operationId: 'AuthController_forgotPassword',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authentication"],
      deprecated: false,
    ),
  });

  ///Get current user's profile
  Future<chopper.Response<UserResponseDto>> apiUsersMeGet() {
    generatedMapping.putIfAbsent(
      UserResponseDto,
      () => UserResponseDto.fromJsonFactory,
    );

    return _apiUsersMeGet();
  }

  ///Get current user's profile
  @GET(path: '/api/users/me')
  Future<chopper.Response<UserResponseDto>> _apiUsersMeGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get current user\'s profile',
      operationId: 'UsersController_getProfile',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Delete current user account
  Future<chopper.Response> apiUsersMeDelete() {
    return _apiUsersMeDelete();
  }

  ///Delete current user account
  @DELETE(path: '/api/users/me')
  Future<chopper.Response> _apiUsersMeDelete({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete current user account',
      operationId: 'UsersController_deleteAccount',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Get current user's settings
  Future<chopper.Response<UserSettingsResponseDto>> apiUsersMeSettingsGet() {
    generatedMapping.putIfAbsent(
      UserSettingsResponseDto,
      () => UserSettingsResponseDto.fromJsonFactory,
    );

    return _apiUsersMeSettingsGet();
  }

  ///Get current user's settings
  @GET(path: '/api/users/me/settings')
  Future<chopper.Response<UserSettingsResponseDto>> _apiUsersMeSettingsGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get current user\'s settings',
      operationId: 'UsersController_getSettings',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Update current user's settings
  Future<chopper.Response<UserSettingsResponseDto>> apiUsersMeSettingsPatch({
    required UpdateSettingsDto? body,
  }) {
    generatedMapping.putIfAbsent(
      UserSettingsResponseDto,
      () => UserSettingsResponseDto.fromJsonFactory,
    );

    return _apiUsersMeSettingsPatch(body: body);
  }

  ///Update current user's settings
  @PATCH(path: '/api/users/me/settings', optionalBody: true)
  Future<chopper.Response<UserSettingsResponseDto>> _apiUsersMeSettingsPatch({
    @Body() required UpdateSettingsDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update current user\'s settings',
      operationId: 'UsersController_updateSettings',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Get all categories
  ///@param isIncome
  Future<chopper.Response<List<CategoryResponseDto>>> apiCategoriesGet({
    required String? isIncome,
  }) {
    generatedMapping.putIfAbsent(
      CategoryResponseDto,
      () => CategoryResponseDto.fromJsonFactory,
    );

    return _apiCategoriesGet(isIncome: isIncome);
  }

  ///Get all categories
  ///@param isIncome
  @GET(path: '/api/categories')
  Future<chopper.Response<List<CategoryResponseDto>>> _apiCategoriesGet({
    @Query('isIncome') required String? isIncome,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get all categories',
      operationId: 'CategoriesController_findAll',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Create a new category
  Future<chopper.Response<CategoryResponseDto>> apiCategoriesPost({
    required CreateCategoryDto? body,
  }) {
    generatedMapping.putIfAbsent(
      CategoryResponseDto,
      () => CategoryResponseDto.fromJsonFactory,
    );

    return _apiCategoriesPost(body: body);
  }

  ///Create a new category
  @POST(path: '/api/categories', optionalBody: true)
  Future<chopper.Response<CategoryResponseDto>> _apiCategoriesPost({
    @Body() required CreateCategoryDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a new category',
      operationId: 'CategoriesController_create',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Delete all categories for user
  ///@param isIncome
  Future<chopper.Response> apiCategoriesDelete({required String? isIncome}) {
    return _apiCategoriesDelete(isIncome: isIncome);
  }

  ///Delete all categories for user
  ///@param isIncome
  @DELETE(path: '/api/categories')
  Future<chopper.Response> _apiCategoriesDelete({
    @Query('isIncome') required String? isIncome,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete all categories for user',
      operationId: 'CategoriesController_removeAll',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Get category by ID
  ///@param id
  Future<chopper.Response<CategoryResponseDto>> apiCategoriesIdGet({
    required String? id,
  }) {
    generatedMapping.putIfAbsent(
      CategoryResponseDto,
      () => CategoryResponseDto.fromJsonFactory,
    );

    return _apiCategoriesIdGet(id: id);
  }

  ///Get category by ID
  ///@param id
  @GET(path: '/api/categories/{id}')
  Future<chopper.Response<CategoryResponseDto>> _apiCategoriesIdGet({
    @Path('id') required String? id,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get category by ID',
      operationId: 'CategoriesController_findOne',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Update category
  ///@param id
  Future<chopper.Response<CategoryResponseDto>> apiCategoriesIdPut({
    required String? id,
    required UpdateCategoryDto? body,
  }) {
    generatedMapping.putIfAbsent(
      CategoryResponseDto,
      () => CategoryResponseDto.fromJsonFactory,
    );

    return _apiCategoriesIdPut(id: id, body: body);
  }

  ///Update category
  ///@param id
  @PUT(path: '/api/categories/{id}', optionalBody: true)
  Future<chopper.Response<CategoryResponseDto>> _apiCategoriesIdPut({
    @Path('id') required String? id,
    @Body() required UpdateCategoryDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update category',
      operationId: 'CategoriesController_update',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Delete category
  ///@param id
  Future<chopper.Response> apiCategoriesIdDelete({required String? id}) {
    return _apiCategoriesIdDelete(id: id);
  }

  ///Delete category
  ///@param id
  @DELETE(path: '/api/categories/{id}')
  Future<chopper.Response> _apiCategoriesIdDelete({
    @Path('id') required String? id,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete category',
      operationId: 'CategoriesController_remove',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Update category limit
  ///@param id
  Future<chopper.Response<CategoryResponseDto>> apiCategoriesIdLimitPatch({
    required String? id,
    required UpdateLimitDto? body,
  }) {
    generatedMapping.putIfAbsent(
      CategoryResponseDto,
      () => CategoryResponseDto.fromJsonFactory,
    );

    return _apiCategoriesIdLimitPatch(id: id, body: body);
  }

  ///Update category limit
  ///@param id
  @PATCH(path: '/api/categories/{id}/limit', optionalBody: true)
  Future<chopper.Response<CategoryResponseDto>> _apiCategoriesIdLimitPatch({
    @Path('id') required String? id,
    @Body() required UpdateLimitDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update category limit',
      operationId: 'CategoriesController_updateLimit',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Restore all category limits
  Future<chopper.Response> apiCategoriesRestoreAllLimitsPost() {
    return _apiCategoriesRestoreAllLimitsPost();
  }

  ///Restore all category limits
  @POST(path: '/api/categories/restore-all-limits', optionalBody: true)
  Future<chopper.Response> _apiCategoriesRestoreAllLimitsPost({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Restore all category limits',
      operationId: 'CategoriesController_restoreAllLimits',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Categories"],
      deprecated: false,
    ),
  });

  ///Get all transactions with filters
  ///@param monthYear
  ///@param year
  ///@param isIncome
  ///@param catId
  Future<chopper.Response<List<TransactionResponseDto>>> apiTransactionsGet({
    required String? monthYear,
    required String? year,
    required String? isIncome,
    required String? catId,
  }) {
    generatedMapping.putIfAbsent(
      TransactionResponseDto,
      () => TransactionResponseDto.fromJsonFactory,
    );

    return _apiTransactionsGet(
      monthYear: monthYear,
      year: year,
      isIncome: isIncome,
      catId: catId,
    );
  }

  ///Get all transactions with filters
  ///@param monthYear
  ///@param year
  ///@param isIncome
  ///@param catId
  @GET(path: '/api/transactions')
  Future<chopper.Response<List<TransactionResponseDto>>> _apiTransactionsGet({
    @Query('monthYear') required String? monthYear,
    @Query('year') required String? year,
    @Query('isIncome') required String? isIncome,
    @Query('catId') required String? catId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get all transactions with filters',
      operationId: 'TransactionsController_findAll',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Create a new transaction
  Future<chopper.Response<TransactionResponseDto>> apiTransactionsPost({
    required CreateTransactionDto? body,
  }) {
    generatedMapping.putIfAbsent(
      TransactionResponseDto,
      () => TransactionResponseDto.fromJsonFactory,
    );

    return _apiTransactionsPost(body: body);
  }

  ///Create a new transaction
  @POST(path: '/api/transactions', optionalBody: true)
  Future<chopper.Response<TransactionResponseDto>> _apiTransactionsPost({
    @Body() required CreateTransactionDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a new transaction',
      operationId: 'TransactionsController_create',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Delete all transactions for user
  Future<chopper.Response> apiTransactionsDelete() {
    return _apiTransactionsDelete();
  }

  ///Delete all transactions for user
  @DELETE(path: '/api/transactions')
  Future<chopper.Response> _apiTransactionsDelete({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete all transactions for user',
      operationId: 'TransactionsController_removeAll',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Update transaction
  ///@param id
  Future<chopper.Response<TransactionResponseDto>> apiTransactionsIdPut({
    required String? id,
    required UpdateTransactionDto? body,
  }) {
    generatedMapping.putIfAbsent(
      TransactionResponseDto,
      () => TransactionResponseDto.fromJsonFactory,
    );

    return _apiTransactionsIdPut(id: id, body: body);
  }

  ///Update transaction
  ///@param id
  @PUT(path: '/api/transactions/{id}', optionalBody: true)
  Future<chopper.Response<TransactionResponseDto>> _apiTransactionsIdPut({
    @Path('id') required String? id,
    @Body() required UpdateTransactionDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update transaction',
      operationId: 'TransactionsController_update',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Delete transaction
  ///@param id
  Future<chopper.Response> apiTransactionsIdDelete({required String? id}) {
    return _apiTransactionsIdDelete(id: id);
  }

  ///Delete transaction
  ///@param id
  @DELETE(path: '/api/transactions/{id}')
  Future<chopper.Response> _apiTransactionsIdDelete({
    @Path('id') required String? id,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete transaction',
      operationId: 'TransactionsController_remove',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Search transactions
  ///@param q
  Future<chopper.Response<List<TransactionResponseDto>>>
  apiTransactionsSearchGet({required String? q}) {
    generatedMapping.putIfAbsent(
      TransactionResponseDto,
      () => TransactionResponseDto.fromJsonFactory,
    );

    return _apiTransactionsSearchGet(q: q);
  }

  ///Search transactions
  ///@param q
  @GET(path: '/api/transactions/search')
  Future<chopper.Response<List<TransactionResponseDto>>>
  _apiTransactionsSearchGet({
    @Query('q') required String? q,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Search transactions',
      operationId: 'TransactionsController_search',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Get yearly statistics
  ///@param year
  Future<chopper.Response<YearlyStatsResponseDto>> apiTransactionsYearlyGet({
    required String? year,
  }) {
    generatedMapping.putIfAbsent(
      YearlyStatsResponseDto,
      () => YearlyStatsResponseDto.fromJsonFactory,
    );

    return _apiTransactionsYearlyGet(year: year);
  }

  ///Get yearly statistics
  ///@param year
  @GET(path: '/api/transactions/yearly')
  Future<chopper.Response<YearlyStatsResponseDto>> _apiTransactionsYearlyGet({
    @Query('year') required String? year,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get yearly statistics',
      operationId: 'TransactionsController_getYearlyStats',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Transactions"],
      deprecated: false,
    ),
  });

  ///Get all schedules
  Future<chopper.Response<List<ScheduleResponseDto>>> apiSchedulesGet() {
    generatedMapping.putIfAbsent(
      ScheduleResponseDto,
      () => ScheduleResponseDto.fromJsonFactory,
    );

    return _apiSchedulesGet();
  }

  ///Get all schedules
  @GET(path: '/api/schedules')
  Future<chopper.Response<List<ScheduleResponseDto>>> _apiSchedulesGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get all schedules',
      operationId: 'SchedulesController_findAll',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Schedules"],
      deprecated: false,
    ),
  });

  ///Create a new schedule
  Future<chopper.Response<ScheduleResponseDto>> apiSchedulesPost({
    required CreateScheduleDto? body,
  }) {
    generatedMapping.putIfAbsent(
      ScheduleResponseDto,
      () => ScheduleResponseDto.fromJsonFactory,
    );

    return _apiSchedulesPost(body: body);
  }

  ///Create a new schedule
  @POST(path: '/api/schedules', optionalBody: true)
  Future<chopper.Response<ScheduleResponseDto>> _apiSchedulesPost({
    @Body() required CreateScheduleDto? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a new schedule',
      operationId: 'SchedulesController_create',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Schedules"],
      deprecated: false,
    ),
  });

  ///Delete all schedules for user
  Future<chopper.Response> apiSchedulesDelete() {
    return _apiSchedulesDelete();
  }

  ///Delete all schedules for user
  @DELETE(path: '/api/schedules')
  Future<chopper.Response> _apiSchedulesDelete({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete all schedules for user',
      operationId: 'SchedulesController_removeAll',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Schedules"],
      deprecated: false,
    ),
  });

  ///Delete schedule by ID
  ///@param id
  Future<chopper.Response> apiSchedulesIdDelete({required num? id}) {
    return _apiSchedulesIdDelete(id: id);
  }

  ///Delete schedule by ID
  ///@param id
  @DELETE(path: '/api/schedules/{id}')
  Future<chopper.Response> _apiSchedulesIdDelete({
    @Path('id') required num? id,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete schedule by ID',
      operationId: 'SchedulesController_remove',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Schedules"],
      deprecated: false,
    ),
  });
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body:
            DateTime.parse((response.body as String).replaceAll('"', ''))
                as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
