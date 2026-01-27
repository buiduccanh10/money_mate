// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_mate_api.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) => RegisterDto(
  email: json['email'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirmPassword'] as String,
);

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
    };

UserResponseDto _$UserResponseDtoFromJson(Map<String, dynamic> json) =>
    UserResponseDto(
      id: json['id'] as String,
      email: json['email'] as String,
      language: json['language'] as String,
      isDark: json['isDark'] as bool,
      isLock: json['isLock'] as bool,
    );

Map<String, dynamic> _$UserResponseDtoToJson(UserResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'language': instance.language,
      'isDark': instance.isDark,
      'isLock': instance.isLock,
    };

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    AuthResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserResponseDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseDtoToJson(AuthResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user.toJson(),
    };

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
};

RefreshTokenDto _$RefreshTokenDtoFromJson(Map<String, dynamic> json) =>
    RefreshTokenDto(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenDtoToJson(RefreshTokenDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

LogoutResponseDto _$LogoutResponseDtoFromJson(Map<String, dynamic> json) =>
    LogoutResponseDto(message: json['message'] as String);

Map<String, dynamic> _$LogoutResponseDtoToJson(LogoutResponseDto instance) =>
    <String, dynamic>{'message': instance.message};

ForgotPasswordDto _$ForgotPasswordDtoFromJson(Map<String, dynamic> json) =>
    ForgotPasswordDto(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordDtoToJson(ForgotPasswordDto instance) =>
    <String, dynamic>{'email': instance.email};

ForgotPasswordResponseDto _$ForgotPasswordResponseDtoFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordResponseDto(message: json['message'] as String);

Map<String, dynamic> _$ForgotPasswordResponseDtoToJson(
  ForgotPasswordResponseDto instance,
) => <String, dynamic>{'message': instance.message};

UserSettingsResponseDto _$UserSettingsResponseDtoFromJson(
  Map<String, dynamic> json,
) => UserSettingsResponseDto(
  language: json['language'] as String,
  isDark: json['isDark'] as bool,
  isLock: json['isLock'] as bool,
);

Map<String, dynamic> _$UserSettingsResponseDtoToJson(
  UserSettingsResponseDto instance,
) => <String, dynamic>{
  'language': instance.language,
  'isDark': instance.isDark,
  'isLock': instance.isLock,
};

UpdateSettingsDto _$UpdateSettingsDtoFromJson(Map<String, dynamic> json) =>
    UpdateSettingsDto(
      language: json['language'] as String?,
      isDark: json['isDark'] as bool?,
      isLock: json['isLock'] as bool?,
    );

Map<String, dynamic> _$UpdateSettingsDtoToJson(UpdateSettingsDto instance) =>
    <String, dynamic>{
      'language': instance.language,
      'isDark': instance.isDark,
      'isLock': instance.isLock,
    };

CategoryResponseDto _$CategoryResponseDtoFromJson(Map<String, dynamic> json) =>
    CategoryResponseDto(
      id: json['id'] as String,
      icon: json['icon'] as String,
      name: json['name'] as String,
      isIncome: json['isIncome'] as bool,
      limit: (json['limit'] as num?)?.toDouble(),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CategoryResponseDtoToJson(
  CategoryResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'icon': instance.icon,
  'name': instance.name,
  'isIncome': instance.isIncome,
  'limit': instance.limit,
  'userId': instance.userId,
};

CreateCategoryDto _$CreateCategoryDtoFromJson(Map<String, dynamic> json) =>
    CreateCategoryDto(
      icon: json['icon'] as String,
      name: json['name'] as String,
      isIncome: json['isIncome'] as bool,
      limit: (json['limit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateCategoryDtoToJson(CreateCategoryDto instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'name': instance.name,
      'isIncome': instance.isIncome,
      'limit': instance.limit,
    };

UpdateCategoryDto _$UpdateCategoryDtoFromJson(Map<String, dynamic> json) =>
    UpdateCategoryDto(
      icon: json['icon'] as String?,
      name: json['name'] as String?,
      isIncome: json['isIncome'] as bool?,
      limit: (json['limit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateCategoryDtoToJson(UpdateCategoryDto instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'name': instance.name,
      'isIncome': instance.isIncome,
      'limit': instance.limit,
    };

UpdateLimitDto _$UpdateLimitDtoFromJson(Map<String, dynamic> json) =>
    UpdateLimitDto(limit: (json['limit'] as num).toDouble());

Map<String, dynamic> _$UpdateLimitDtoToJson(UpdateLimitDto instance) =>
    <String, dynamic>{'limit': instance.limit};

TransactionResponseDto _$TransactionResponseDtoFromJson(
  Map<String, dynamic> json,
) => TransactionResponseDto(
  id: json['id'] as String,
  date: json['date'] as String,
  description: json['description'] as String?,
  money: (json['money'] as num).toDouble(),
  catId: json['catId'] as String,
  isIncome: json['isIncome'] as bool,
  userId: json['userId'] as String,
  category: json['category'] == null
      ? null
      : CategoryResponseDto.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionResponseDtoToJson(
  TransactionResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'description': instance.description,
  'money': instance.money,
  'catId': instance.catId,
  'isIncome': instance.isIncome,
  'userId': instance.userId,
  'category': instance.category?.toJson(),
};

CreateTransactionDto _$CreateTransactionDtoFromJson(
  Map<String, dynamic> json,
) => CreateTransactionDto(
  date: json['date'] as String,
  description: json['description'] as String?,
  money: (json['money'] as num).toDouble(),
  catId: json['catId'] as String,
  isIncome: json['isIncome'] as bool,
);

Map<String, dynamic> _$CreateTransactionDtoToJson(
  CreateTransactionDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'description': instance.description,
  'money': instance.money,
  'catId': instance.catId,
  'isIncome': instance.isIncome,
};

UpdateTransactionDto _$UpdateTransactionDtoFromJson(
  Map<String, dynamic> json,
) => UpdateTransactionDto(
  date: json['date'] as String?,
  description: json['description'] as String?,
  money: (json['money'] as num?)?.toDouble(),
  catId: json['catId'] as String?,
  isIncome: json['isIncome'] as bool?,
);

Map<String, dynamic> _$UpdateTransactionDtoToJson(
  UpdateTransactionDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'description': instance.description,
  'money': instance.money,
  'catId': instance.catId,
  'isIncome': instance.isIncome,
};

TransactionSummaryDto _$TransactionSummaryDtoFromJson(
  Map<String, dynamic> json,
) => TransactionSummaryDto(
  income: (json['income'] as num).toDouble(),
  expense: (json['expense'] as num).toDouble(),
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$TransactionSummaryDtoToJson(
  TransactionSummaryDto instance,
) => <String, dynamic>{
  'income': instance.income,
  'expense': instance.expense,
  'balance': instance.balance,
};

YearlyStatsResponseDto _$YearlyStatsResponseDtoFromJson(
  Map<String, dynamic> json,
) => YearlyStatsResponseDto(
  year: json['year'] as String,
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) => TransactionResponseDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  summary: TransactionSummaryDto.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$YearlyStatsResponseDtoToJson(
  YearlyStatsResponseDto instance,
) => <String, dynamic>{
  'year': instance.year,
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
  'summary': instance.summary.toJson(),
};

ScheduleResponseDto _$ScheduleResponseDtoFromJson(Map<String, dynamic> json) =>
    ScheduleResponseDto(
      id: (json['id'] as num).toDouble(),
      date: json['date'] as String,
      description: json['description'] as String?,
      money: (json['money'] as num).toDouble(),
      catId: json['catId'] as String,
      icon: json['icon'] as String,
      name: json['name'] as String,
      isIncome: json['isIncome'] as bool,
      option: scheduleResponseDtoOptionFromJson(json['option']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$ScheduleResponseDtoToJson(
  ScheduleResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'description': instance.description,
  'money': instance.money,
  'catId': instance.catId,
  'icon': instance.icon,
  'name': instance.name,
  'isIncome': instance.isIncome,
  'option': scheduleResponseDtoOptionToJson(instance.option),
  'userId': instance.userId,
};

CreateScheduleDto _$CreateScheduleDtoFromJson(Map<String, dynamic> json) =>
    CreateScheduleDto(
      date: json['date'] as String,
      description: json['description'] as String?,
      money: (json['money'] as num).toDouble(),
      catId: json['catId'] as String,
      icon: json['icon'] as String,
      name: json['name'] as String,
      isIncome: json['isIncome'] as bool,
      option: createScheduleDtoOptionFromJson(json['option']),
    );

Map<String, dynamic> _$CreateScheduleDtoToJson(CreateScheduleDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'description': instance.description,
      'money': instance.money,
      'catId': instance.catId,
      'icon': instance.icon,
      'name': instance.name,
      'isIncome': instance.isIncome,
      'option': createScheduleDtoOptionToJson(instance.option),
    };
