// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'money_mate_api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MoneyMateApi extends MoneyMateApi {
  _$MoneyMateApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MoneyMateApi;

  @override
  Future<Response<AuthResponseDto>> _apiAuthRegisterPost({
    required RegisterDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/auth/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<AuthResponseDto, AuthResponseDto>($request);
  }

  @override
  Future<Response<AuthResponseDto>> _apiAuthLoginPost({
    required LoginDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<AuthResponseDto, AuthResponseDto>($request);
  }

  @override
  Future<Response<AuthResponseDto>> _apiAuthRefreshPost({
    required RefreshTokenDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/auth/refresh');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<AuthResponseDto, AuthResponseDto>($request);
  }

  @override
  Future<Response<LogoutResponseDto>> _apiAuthLogoutPost({
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
  }) {
    final Uri $url = Uri.parse('/api/auth/logout');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<LogoutResponseDto, LogoutResponseDto>($request);
  }

  @override
  Future<Response<ForgotPasswordResponseDto>> _apiAuthForgotPasswordPost({
    required ForgotPasswordDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/auth/forgot-password');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ForgotPasswordResponseDto, ForgotPasswordResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<UserResponseDto>> _apiUsersMeGet({
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
  }) {
    final Uri $url = Uri.parse('/api/users/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<UserResponseDto, UserResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiUsersMeDelete({
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
  }) {
    final Uri $url = Uri.parse('/api/users/me');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<UserResponseDto>> _apiUsersMeAvatarPatch({
    List<int>? file,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update current user\'s avatar',
      operationId: 'UsersController_updateAvatar',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Users"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/users/me/avatar');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<List<int>?>('file', file),
    ];
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      tag: swaggerMetaData,
    );
    return client.send<UserResponseDto, UserResponseDto>($request);
  }

  @override
  Future<Response<UserResponseDto>> _apiUsersMeProfilePatch({
    required UpdateProfileDto? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update current user\'s profile info',
      operationId: 'UsersController_updateProfile',
      consumes: [],
      produces: [],
      security: ["bearer"],
      tags: ["Users"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/users/me/profile');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<UserResponseDto, UserResponseDto>($request);
  }

  @override
  Future<Response<UserSettingsResponseDto>> _apiUsersMeSettingsGet({
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
  }) {
    final Uri $url = Uri.parse('/api/users/me/settings');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<UserSettingsResponseDto, UserSettingsResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<UserSettingsResponseDto>> _apiUsersMeSettingsPatch({
    required UpdateSettingsDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/users/me/settings');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<UserSettingsResponseDto, UserSettingsResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<List<CategoryResponseDto>>> _apiCategoriesGet({
    required String? isIncome,
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
  }) {
    final Uri $url = Uri.parse('/api/categories');
    final Map<String, dynamic> $params = <String, dynamic>{
      'isIncome': isIncome,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<CategoryResponseDto>, CategoryResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<CategoryResponseDto>> _apiCategoriesPost({
    required CreateCategoryDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/categories');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<CategoryResponseDto, CategoryResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiCategoriesDelete({
    required String? isIncome,
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
  }) {
    final Uri $url = Uri.parse('/api/categories');
    final Map<String, dynamic> $params = <String, dynamic>{
      'isIncome': isIncome,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CategoryResponseDto>> _apiCategoriesIdGet({
    required String? id,
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
  }) {
    final Uri $url = Uri.parse('/api/categories/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<CategoryResponseDto, CategoryResponseDto>($request);
  }

  @override
  Future<Response<CategoryResponseDto>> _apiCategoriesIdPut({
    required String? id,
    required UpdateCategoryDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/categories/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<CategoryResponseDto, CategoryResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiCategoriesIdDelete({
    required String? id,
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
  }) {
    final Uri $url = Uri.parse('/api/categories/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CategoryResponseDto>> _apiCategoriesIdLimitPatch({
    required String? id,
    required UpdateLimitDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/categories/${id}/limit');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<CategoryResponseDto, CategoryResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiCategoriesRestoreAllLimitsPost({
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
  }) {
    final Uri $url = Uri.parse('/api/categories/restore-all-limits');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<TransactionResponseDto>>> _apiTransactionsGet({
    required String? monthYear,
    required String? year,
    required String? isIncome,
    required String? catId,
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
  }) {
    final Uri $url = Uri.parse('/api/transactions');
    final Map<String, dynamic> $params = <String, dynamic>{
      'monthYear': monthYear,
      'year': year,
      'isIncome': isIncome,
      'catId': catId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<TransactionResponseDto>, TransactionResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<TransactionResponseDto>> _apiTransactionsPost({
    required CreateTransactionDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/transactions');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TransactionResponseDto, TransactionResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _apiTransactionsDelete({
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
  }) {
    final Uri $url = Uri.parse('/api/transactions');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<TransactionResponseDto>> _apiTransactionsIdPut({
    required String? id,
    required UpdateTransactionDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/transactions/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TransactionResponseDto, TransactionResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _apiTransactionsIdDelete({
    required String? id,
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
  }) {
    final Uri $url = Uri.parse('/api/transactions/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<TransactionResponseDto>>> _apiTransactionsSearchGet({
    required String? q,
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
  }) {
    final Uri $url = Uri.parse('/api/transactions/search');
    final Map<String, dynamic> $params = <String, dynamic>{'q': q};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<TransactionResponseDto>, TransactionResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<YearlyStatsResponseDto>> _apiTransactionsYearlyGet({
    required String? year,
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
  }) {
    final Uri $url = Uri.parse('/api/transactions/yearly');
    final Map<String, dynamic> $params = <String, dynamic>{'year': year};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<YearlyStatsResponseDto, YearlyStatsResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<List<ScheduleResponseDto>>> _apiSchedulesGet({
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
  }) {
    final Uri $url = Uri.parse('/api/schedules');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<ScheduleResponseDto>, ScheduleResponseDto>(
      $request,
    );
  }

  @override
  Future<Response<ScheduleResponseDto>> _apiSchedulesPost({
    required CreateScheduleDto? body,
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
  }) {
    final Uri $url = Uri.parse('/api/schedules');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ScheduleResponseDto, ScheduleResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiSchedulesDelete({
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
  }) {
    final Uri $url = Uri.parse('/api/schedules');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiSchedulesIdDelete({
    required num? id,
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
  }) {
    final Uri $url = Uri.parse('/api/schedules/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
