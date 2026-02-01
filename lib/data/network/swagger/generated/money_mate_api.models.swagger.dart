// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'money_mate_api.enums.swagger.dart' as enums;

part 'money_mate_api.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class RegisterDto {
  const RegisterDto({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.language,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);

  static const toJsonFactory = _$RegisterDtoToJson;
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'confirmPassword')
  final String confirmPassword;
  @JsonKey(name: 'language')
  final String? language;
  static const fromJsonFactory = _$RegisterDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterDto &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.confirmPassword, confirmPassword) ||
                const DeepCollectionEquality().equals(
                  other.confirmPassword,
                  confirmPassword,
                )) &&
            (identical(other.language, language) ||
                const DeepCollectionEquality().equals(
                  other.language,
                  language,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(confirmPassword) ^
      const DeepCollectionEquality().hash(language) ^
      runtimeType.hashCode;
}

extension $RegisterDtoExtension on RegisterDto {
  RegisterDto copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? language,
  }) {
    return RegisterDto(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      language: language ?? this.language,
    );
  }

  RegisterDto copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? password,
    Wrapped<String>? confirmPassword,
    Wrapped<String?>? language,
  }) {
    return RegisterDto(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
      confirmPassword: (confirmPassword != null
          ? confirmPassword.value
          : this.confirmPassword),
      language: (language != null ? language.value : this.language),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserResponseDto {
  const UserResponseDto({
    required this.id,
    required this.email,
    required this.language,
    required this.isDark,
    required this.isLock,
    this.name,
    this.avatar,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserResponseDtoFromJson(json);

  static const toJsonFactory = _$UserResponseDtoToJson;
  Map<String, dynamic> toJson() => _$UserResponseDtoToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'language')
  final String language;
  @JsonKey(name: 'isDark')
  final bool isDark;
  @JsonKey(name: 'isLock')
  final bool isLock;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'avatar')
  final String? avatar;
  static const fromJsonFactory = _$UserResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.language, language) ||
                const DeepCollectionEquality().equals(
                  other.language,
                  language,
                )) &&
            (identical(other.isDark, isDark) ||
                const DeepCollectionEquality().equals(other.isDark, isDark)) &&
            (identical(other.isLock, isLock) ||
                const DeepCollectionEquality().equals(other.isLock, isLock)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.avatar, avatar) ||
                const DeepCollectionEquality().equals(other.avatar, avatar)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(language) ^
      const DeepCollectionEquality().hash(isDark) ^
      const DeepCollectionEquality().hash(isLock) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(avatar) ^
      runtimeType.hashCode;
}

extension $UserResponseDtoExtension on UserResponseDto {
  UserResponseDto copyWith({
    String? id,
    String? email,
    String? language,
    bool? isDark,
    bool? isLock,
    String? name,
    String? avatar,
  }) {
    return UserResponseDto(
      id: id ?? this.id,
      email: email ?? this.email,
      language: language ?? this.language,
      isDark: isDark ?? this.isDark,
      isLock: isLock ?? this.isLock,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  UserResponseDto copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<String>? email,
    Wrapped<String>? language,
    Wrapped<bool>? isDark,
    Wrapped<bool>? isLock,
    Wrapped<String?>? name,
    Wrapped<String?>? avatar,
  }) {
    return UserResponseDto(
      id: (id != null ? id.value : this.id),
      email: (email != null ? email.value : this.email),
      language: (language != null ? language.value : this.language),
      isDark: (isDark != null ? isDark.value : this.isDark),
      isLock: (isLock != null ? isLock.value : this.isLock),
      name: (name != null ? name.value : this.name),
      avatar: (avatar != null ? avatar.value : this.avatar),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AuthResponseDto {
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  static const toJsonFactory = _$AuthResponseDtoToJson;
  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);

  @JsonKey(name: 'accessToken')
  final String accessToken;
  @JsonKey(name: 'refreshToken')
  final String refreshToken;
  @JsonKey(name: 'user')
  final UserResponseDto user;
  static const fromJsonFactory = _$AuthResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AuthResponseDto &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $AuthResponseDtoExtension on AuthResponseDto {
  AuthResponseDto copyWith({
    String? accessToken,
    String? refreshToken,
    UserResponseDto? user,
  }) {
    return AuthResponseDto(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  AuthResponseDto copyWithWrapped({
    Wrapped<String>? accessToken,
    Wrapped<String>? refreshToken,
    Wrapped<UserResponseDto>? user,
  }) {
    return AuthResponseDto(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
      user: (user != null ? user.value : this.user),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LoginDto {
  const LoginDto({required this.email, required this.password});

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  static const toJsonFactory = _$LoginDtoToJson;
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$LoginDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginDto &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $LoginDtoExtension on LoginDto {
  LoginDto copyWith({String? email, String? password}) {
    return LoginDto(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  LoginDto copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? password,
  }) {
    return LoginDto(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RefreshTokenDto {
  const RefreshTokenDto({required this.refreshToken});

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDtoFromJson(json);

  static const toJsonFactory = _$RefreshTokenDtoToJson;
  Map<String, dynamic> toJson() => _$RefreshTokenDtoToJson(this);

  @JsonKey(name: 'refreshToken')
  final String refreshToken;
  static const fromJsonFactory = _$RefreshTokenDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RefreshTokenDto &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(refreshToken) ^ runtimeType.hashCode;
}

extension $RefreshTokenDtoExtension on RefreshTokenDto {
  RefreshTokenDto copyWith({String? refreshToken}) {
    return RefreshTokenDto(refreshToken: refreshToken ?? this.refreshToken);
  }

  RefreshTokenDto copyWithWrapped({Wrapped<String>? refreshToken}) {
    return RefreshTokenDto(
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LogoutResponseDto {
  const LogoutResponseDto({required this.message});

  factory LogoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseDtoFromJson(json);

  static const toJsonFactory = _$LogoutResponseDtoToJson;
  Map<String, dynamic> toJson() => _$LogoutResponseDtoToJson(this);

  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$LogoutResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LogoutResponseDto &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $LogoutResponseDtoExtension on LogoutResponseDto {
  LogoutResponseDto copyWith({String? message}) {
    return LogoutResponseDto(message: message ?? this.message);
  }

  LogoutResponseDto copyWithWrapped({Wrapped<String>? message}) {
    return LogoutResponseDto(
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ForgotPasswordDto {
  const ForgotPasswordDto({required this.email});

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDtoFromJson(json);

  static const toJsonFactory = _$ForgotPasswordDtoToJson;
  Map<String, dynamic> toJson() => _$ForgotPasswordDtoToJson(this);

  @JsonKey(name: 'email')
  final String email;
  static const fromJsonFactory = _$ForgotPasswordDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ForgotPasswordDto &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^ runtimeType.hashCode;
}

extension $ForgotPasswordDtoExtension on ForgotPasswordDto {
  ForgotPasswordDto copyWith({String? email}) {
    return ForgotPasswordDto(email: email ?? this.email);
  }

  ForgotPasswordDto copyWithWrapped({Wrapped<String>? email}) {
    return ForgotPasswordDto(email: (email != null ? email.value : this.email));
  }
}

@JsonSerializable(explicitToJson: true)
class ForgotPasswordResponseDto {
  const ForgotPasswordResponseDto({required this.message});

  factory ForgotPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseDtoFromJson(json);

  static const toJsonFactory = _$ForgotPasswordResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ForgotPasswordResponseDtoToJson(this);

  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$ForgotPasswordResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ForgotPasswordResponseDto &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ForgotPasswordResponseDtoExtension on ForgotPasswordResponseDto {
  ForgotPasswordResponseDto copyWith({String? message}) {
    return ForgotPasswordResponseDto(message: message ?? this.message);
  }

  ForgotPasswordResponseDto copyWithWrapped({Wrapped<String>? message}) {
    return ForgotPasswordResponseDto(
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateProfileDto {
  const UpdateProfileDto({this.name, this.avatar, this.email, this.password});

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);

  static const toJsonFactory = _$UpdateProfileDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateProfileDtoToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'avatar')
  final String? avatar;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'password')
  final String? password;
  static const fromJsonFactory = _$UpdateProfileDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateProfileDto &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.avatar, avatar) ||
                const DeepCollectionEquality().equals(other.avatar, avatar)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(avatar) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $UpdateProfileDtoExtension on UpdateProfileDto {
  UpdateProfileDto copyWith({
    String? name,
    String? avatar,
    String? email,
    String? password,
  }) {
    return UpdateProfileDto(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  UpdateProfileDto copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? avatar,
    Wrapped<String?>? email,
    Wrapped<String?>? password,
  }) {
    return UpdateProfileDto(
      name: (name != null ? name.value : this.name),
      avatar: (avatar != null ? avatar.value : this.avatar),
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserSettingsResponseDto {
  const UserSettingsResponseDto({
    required this.language,
    required this.isDark,
    required this.isLock,
  });

  factory UserSettingsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsResponseDtoFromJson(json);

  static const toJsonFactory = _$UserSettingsResponseDtoToJson;
  Map<String, dynamic> toJson() => _$UserSettingsResponseDtoToJson(this);

  @JsonKey(name: 'language')
  final String language;
  @JsonKey(name: 'isDark')
  final bool isDark;
  @JsonKey(name: 'isLock')
  final bool isLock;
  static const fromJsonFactory = _$UserSettingsResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserSettingsResponseDto &&
            (identical(other.language, language) ||
                const DeepCollectionEquality().equals(
                  other.language,
                  language,
                )) &&
            (identical(other.isDark, isDark) ||
                const DeepCollectionEquality().equals(other.isDark, isDark)) &&
            (identical(other.isLock, isLock) ||
                const DeepCollectionEquality().equals(other.isLock, isLock)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(language) ^
      const DeepCollectionEquality().hash(isDark) ^
      const DeepCollectionEquality().hash(isLock) ^
      runtimeType.hashCode;
}

extension $UserSettingsResponseDtoExtension on UserSettingsResponseDto {
  UserSettingsResponseDto copyWith({
    String? language,
    bool? isDark,
    bool? isLock,
  }) {
    return UserSettingsResponseDto(
      language: language ?? this.language,
      isDark: isDark ?? this.isDark,
      isLock: isLock ?? this.isLock,
    );
  }

  UserSettingsResponseDto copyWithWrapped({
    Wrapped<String>? language,
    Wrapped<bool>? isDark,
    Wrapped<bool>? isLock,
  }) {
    return UserSettingsResponseDto(
      language: (language != null ? language.value : this.language),
      isDark: (isDark != null ? isDark.value : this.isDark),
      isLock: (isLock != null ? isLock.value : this.isLock),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateSettingsDto {
  const UpdateSettingsDto({this.language, this.isDark, this.isLock});

  factory UpdateSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateSettingsDtoFromJson(json);

  static const toJsonFactory = _$UpdateSettingsDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateSettingsDtoToJson(this);

  @JsonKey(name: 'language')
  final String? language;
  @JsonKey(name: 'isDark')
  final bool? isDark;
  @JsonKey(name: 'isLock')
  final bool? isLock;
  static const fromJsonFactory = _$UpdateSettingsDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateSettingsDto &&
            (identical(other.language, language) ||
                const DeepCollectionEquality().equals(
                  other.language,
                  language,
                )) &&
            (identical(other.isDark, isDark) ||
                const DeepCollectionEquality().equals(other.isDark, isDark)) &&
            (identical(other.isLock, isLock) ||
                const DeepCollectionEquality().equals(other.isLock, isLock)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(language) ^
      const DeepCollectionEquality().hash(isDark) ^
      const DeepCollectionEquality().hash(isLock) ^
      runtimeType.hashCode;
}

extension $UpdateSettingsDtoExtension on UpdateSettingsDto {
  UpdateSettingsDto copyWith({String? language, bool? isDark, bool? isLock}) {
    return UpdateSettingsDto(
      language: language ?? this.language,
      isDark: isDark ?? this.isDark,
      isLock: isLock ?? this.isLock,
    );
  }

  UpdateSettingsDto copyWithWrapped({
    Wrapped<String?>? language,
    Wrapped<bool?>? isDark,
    Wrapped<bool?>? isLock,
  }) {
    return UpdateSettingsDto(
      language: (language != null ? language.value : this.language),
      isDark: (isDark != null ? isDark.value : this.isDark),
      isLock: (isLock != null ? isLock.value : this.isLock),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CategoryResponseDto {
  const CategoryResponseDto({
    required this.id,
    required this.icon,
    required this.name,
    required this.isIncome,
    this.limit,
    this.limitType,
    required this.userId,
  });

  factory CategoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseDtoFromJson(json);

  static const toJsonFactory = _$CategoryResponseDtoToJson;
  Map<String, dynamic> toJson() => _$CategoryResponseDtoToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'isIncome')
  final bool isIncome;
  @JsonKey(name: 'limit')
  final double? limit;
  @JsonKey(
    name: 'limitType',
    toJson: categoryResponseDtoLimitTypeNullableToJson,
    fromJson: categoryResponseDtoLimitTypeNullableFromJson,
  )
  final enums.CategoryResponseDtoLimitType? limitType;
  @JsonKey(name: 'userId')
  final String userId;
  static const fromJsonFactory = _$CategoryResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CategoryResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.limitType, limitType) ||
                const DeepCollectionEquality().equals(
                  other.limitType,
                  limitType,
                )) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(limitType) ^
      const DeepCollectionEquality().hash(userId) ^
      runtimeType.hashCode;
}

extension $CategoryResponseDtoExtension on CategoryResponseDto {
  CategoryResponseDto copyWith({
    String? id,
    String? icon,
    String? name,
    bool? isIncome,
    double? limit,
    enums.CategoryResponseDtoLimitType? limitType,
    String? userId,
  }) {
    return CategoryResponseDto(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
      limit: limit ?? this.limit,
      limitType: limitType ?? this.limitType,
      userId: userId ?? this.userId,
    );
  }

  CategoryResponseDto copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<String>? icon,
    Wrapped<String>? name,
    Wrapped<bool>? isIncome,
    Wrapped<double?>? limit,
    Wrapped<enums.CategoryResponseDtoLimitType?>? limitType,
    Wrapped<String>? userId,
  }) {
    return CategoryResponseDto(
      id: (id != null ? id.value : this.id),
      icon: (icon != null ? icon.value : this.icon),
      name: (name != null ? name.value : this.name),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      limit: (limit != null ? limit.value : this.limit),
      limitType: (limitType != null ? limitType.value : this.limitType),
      userId: (userId != null ? userId.value : this.userId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateCategoryDto {
  const CreateCategoryDto({
    required this.icon,
    required this.name,
    required this.isIncome,
    this.limit,
    this.limitType,
  });

  factory CreateCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryDtoFromJson(json);

  static const toJsonFactory = _$CreateCategoryDtoToJson;
  Map<String, dynamic> toJson() => _$CreateCategoryDtoToJson(this);

  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'isIncome')
  final bool isIncome;
  @JsonKey(name: 'limit')
  final double? limit;
  @JsonKey(
    name: 'limitType',
    toJson: createCategoryDtoLimitTypeNullableToJson,
    fromJson: createCategoryDtoLimitTypeLimitTypeNullableFromJson,
  )
  final enums.CreateCategoryDtoLimitType? limitType;
  static enums.CreateCategoryDtoLimitType?
  createCategoryDtoLimitTypeLimitTypeNullableFromJson(Object? value) =>
      createCategoryDtoLimitTypeNullableFromJson(
        value,
        enums.CreateCategoryDtoLimitType.monthly,
      );

  static const fromJsonFactory = _$CreateCategoryDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateCategoryDto &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.limitType, limitType) ||
                const DeepCollectionEquality().equals(
                  other.limitType,
                  limitType,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(limitType) ^
      runtimeType.hashCode;
}

extension $CreateCategoryDtoExtension on CreateCategoryDto {
  CreateCategoryDto copyWith({
    String? icon,
    String? name,
    bool? isIncome,
    double? limit,
    enums.CreateCategoryDtoLimitType? limitType,
  }) {
    return CreateCategoryDto(
      icon: icon ?? this.icon,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
      limit: limit ?? this.limit,
      limitType: limitType ?? this.limitType,
    );
  }

  CreateCategoryDto copyWithWrapped({
    Wrapped<String>? icon,
    Wrapped<String>? name,
    Wrapped<bool>? isIncome,
    Wrapped<double?>? limit,
    Wrapped<enums.CreateCategoryDtoLimitType?>? limitType,
  }) {
    return CreateCategoryDto(
      icon: (icon != null ? icon.value : this.icon),
      name: (name != null ? name.value : this.name),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      limit: (limit != null ? limit.value : this.limit),
      limitType: (limitType != null ? limitType.value : this.limitType),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateCategoryDto {
  const UpdateCategoryDto({
    this.icon,
    this.name,
    this.isIncome,
    this.limit,
    this.limitType,
  });

  factory UpdateCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryDtoFromJson(json);

  static const toJsonFactory = _$UpdateCategoryDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateCategoryDtoToJson(this);

  @JsonKey(name: 'icon')
  final String? icon;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'isIncome')
  final bool? isIncome;
  @JsonKey(name: 'limit')
  final double? limit;
  @JsonKey(
    name: 'limitType',
    toJson: updateCategoryDtoLimitTypeNullableToJson,
    fromJson: updateCategoryDtoLimitTypeNullableFromJson,
  )
  final enums.UpdateCategoryDtoLimitType? limitType;
  static const fromJsonFactory = _$UpdateCategoryDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateCategoryDto &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.limitType, limitType) ||
                const DeepCollectionEquality().equals(
                  other.limitType,
                  limitType,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(limitType) ^
      runtimeType.hashCode;
}

extension $UpdateCategoryDtoExtension on UpdateCategoryDto {
  UpdateCategoryDto copyWith({
    String? icon,
    String? name,
    bool? isIncome,
    double? limit,
    enums.UpdateCategoryDtoLimitType? limitType,
  }) {
    return UpdateCategoryDto(
      icon: icon ?? this.icon,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
      limit: limit ?? this.limit,
      limitType: limitType ?? this.limitType,
    );
  }

  UpdateCategoryDto copyWithWrapped({
    Wrapped<String?>? icon,
    Wrapped<String?>? name,
    Wrapped<bool?>? isIncome,
    Wrapped<double?>? limit,
    Wrapped<enums.UpdateCategoryDtoLimitType?>? limitType,
  }) {
    return UpdateCategoryDto(
      icon: (icon != null ? icon.value : this.icon),
      name: (name != null ? name.value : this.name),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      limit: (limit != null ? limit.value : this.limit),
      limitType: (limitType != null ? limitType.value : this.limitType),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateLimitDto {
  const UpdateLimitDto({required this.limit, this.limitType});

  factory UpdateLimitDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateLimitDtoFromJson(json);

  static const toJsonFactory = _$UpdateLimitDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateLimitDtoToJson(this);

  @JsonKey(name: 'limit')
  final double limit;
  @JsonKey(
    name: 'limitType',
    toJson: updateLimitDtoLimitTypeNullableToJson,
    fromJson: updateLimitDtoLimitTypeNullableFromJson,
  )
  final enums.UpdateLimitDtoLimitType? limitType;
  static const fromJsonFactory = _$UpdateLimitDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateLimitDto &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.limitType, limitType) ||
                const DeepCollectionEquality().equals(
                  other.limitType,
                  limitType,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(limitType) ^
      runtimeType.hashCode;
}

extension $UpdateLimitDtoExtension on UpdateLimitDto {
  UpdateLimitDto copyWith({
    double? limit,
    enums.UpdateLimitDtoLimitType? limitType,
  }) {
    return UpdateLimitDto(
      limit: limit ?? this.limit,
      limitType: limitType ?? this.limitType,
    );
  }

  UpdateLimitDto copyWithWrapped({
    Wrapped<double>? limit,
    Wrapped<enums.UpdateLimitDtoLimitType?>? limitType,
  }) {
    return UpdateLimitDto(
      limit: (limit != null ? limit.value : this.limit),
      limitType: (limitType != null ? limitType.value : this.limitType),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TransactionResponseDto {
  const TransactionResponseDto({
    required this.id,
    required this.date,
    required this.time,
    this.description,
    required this.money,
    required this.catId,
    required this.isIncome,
    required this.userId,
    this.category,
  });

  factory TransactionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseDtoFromJson(json);

  static const toJsonFactory = _$TransactionResponseDtoToJson;
  Map<String, dynamic> toJson() => _$TransactionResponseDtoToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'date')
  final String date;
  @JsonKey(name: 'time')
  final String time;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'money')
  final double money;
  @JsonKey(name: 'catId')
  final String catId;
  @JsonKey(name: 'isIncome')
  final bool isIncome;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'category')
  final CategoryResponseDto? category;
  static const fromJsonFactory = _$TransactionResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TransactionResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.money, money) ||
                const DeepCollectionEquality().equals(other.money, money)) &&
            (identical(other.catId, catId) ||
                const DeepCollectionEquality().equals(other.catId, catId)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality().equals(
                  other.category,
                  category,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(money) ^
      const DeepCollectionEquality().hash(catId) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(category) ^
      runtimeType.hashCode;
}

extension $TransactionResponseDtoExtension on TransactionResponseDto {
  TransactionResponseDto copyWith({
    String? id,
    String? date,
    String? time,
    String? description,
    double? money,
    String? catId,
    bool? isIncome,
    String? userId,
    CategoryResponseDto? category,
  }) {
    return TransactionResponseDto(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      money: money ?? this.money,
      catId: catId ?? this.catId,
      isIncome: isIncome ?? this.isIncome,
      userId: userId ?? this.userId,
      category: category ?? this.category,
    );
  }

  TransactionResponseDto copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<String>? date,
    Wrapped<String>? time,
    Wrapped<String?>? description,
    Wrapped<double>? money,
    Wrapped<String>? catId,
    Wrapped<bool>? isIncome,
    Wrapped<String>? userId,
    Wrapped<CategoryResponseDto?>? category,
  }) {
    return TransactionResponseDto(
      id: (id != null ? id.value : this.id),
      date: (date != null ? date.value : this.date),
      time: (time != null ? time.value : this.time),
      description: (description != null ? description.value : this.description),
      money: (money != null ? money.value : this.money),
      catId: (catId != null ? catId.value : this.catId),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      userId: (userId != null ? userId.value : this.userId),
      category: (category != null ? category.value : this.category),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateTransactionDto {
  const CreateTransactionDto({
    required this.date,
    this.description,
    required this.money,
    required this.catId,
    required this.isIncome,
    this.time,
  });

  factory CreateTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionDtoFromJson(json);

  static const toJsonFactory = _$CreateTransactionDtoToJson;
  Map<String, dynamic> toJson() => _$CreateTransactionDtoToJson(this);

  @JsonKey(name: 'date')
  final String date;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'money')
  final double money;
  @JsonKey(name: 'catId')
  final String catId;
  @JsonKey(name: 'isIncome')
  final bool isIncome;
  @JsonKey(name: 'time')
  final String? time;
  static const fromJsonFactory = _$CreateTransactionDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateTransactionDto &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.money, money) ||
                const DeepCollectionEquality().equals(other.money, money)) &&
            (identical(other.catId, catId) ||
                const DeepCollectionEquality().equals(other.catId, catId)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(money) ^
      const DeepCollectionEquality().hash(catId) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(time) ^
      runtimeType.hashCode;
}

extension $CreateTransactionDtoExtension on CreateTransactionDto {
  CreateTransactionDto copyWith({
    String? date,
    String? description,
    double? money,
    String? catId,
    bool? isIncome,
    String? time,
  }) {
    return CreateTransactionDto(
      date: date ?? this.date,
      description: description ?? this.description,
      money: money ?? this.money,
      catId: catId ?? this.catId,
      isIncome: isIncome ?? this.isIncome,
      time: time ?? this.time,
    );
  }

  CreateTransactionDto copyWithWrapped({
    Wrapped<String>? date,
    Wrapped<String?>? description,
    Wrapped<double>? money,
    Wrapped<String>? catId,
    Wrapped<bool>? isIncome,
    Wrapped<String?>? time,
  }) {
    return CreateTransactionDto(
      date: (date != null ? date.value : this.date),
      description: (description != null ? description.value : this.description),
      money: (money != null ? money.value : this.money),
      catId: (catId != null ? catId.value : this.catId),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      time: (time != null ? time.value : this.time),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateTransactionDto {
  const UpdateTransactionDto({
    this.date,
    this.description,
    this.money,
    this.catId,
    this.isIncome,
    this.time,
  });

  factory UpdateTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTransactionDtoFromJson(json);

  static const toJsonFactory = _$UpdateTransactionDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateTransactionDtoToJson(this);

  @JsonKey(name: 'date')
  final String? date;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'money')
  final double? money;
  @JsonKey(name: 'catId')
  final String? catId;
  @JsonKey(name: 'isIncome')
  final bool? isIncome;
  @JsonKey(name: 'time')
  final String? time;
  static const fromJsonFactory = _$UpdateTransactionDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateTransactionDto &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.money, money) ||
                const DeepCollectionEquality().equals(other.money, money)) &&
            (identical(other.catId, catId) ||
                const DeepCollectionEquality().equals(other.catId, catId)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(money) ^
      const DeepCollectionEquality().hash(catId) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(time) ^
      runtimeType.hashCode;
}

extension $UpdateTransactionDtoExtension on UpdateTransactionDto {
  UpdateTransactionDto copyWith({
    String? date,
    String? description,
    double? money,
    String? catId,
    bool? isIncome,
    String? time,
  }) {
    return UpdateTransactionDto(
      date: date ?? this.date,
      description: description ?? this.description,
      money: money ?? this.money,
      catId: catId ?? this.catId,
      isIncome: isIncome ?? this.isIncome,
      time: time ?? this.time,
    );
  }

  UpdateTransactionDto copyWithWrapped({
    Wrapped<String?>? date,
    Wrapped<String?>? description,
    Wrapped<double?>? money,
    Wrapped<String?>? catId,
    Wrapped<bool?>? isIncome,
    Wrapped<String?>? time,
  }) {
    return UpdateTransactionDto(
      date: (date != null ? date.value : this.date),
      description: (description != null ? description.value : this.description),
      money: (money != null ? money.value : this.money),
      catId: (catId != null ? catId.value : this.catId),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      time: (time != null ? time.value : this.time),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TransactionSummaryDto {
  const TransactionSummaryDto({
    required this.income,
    required this.expense,
    required this.balance,
  });

  factory TransactionSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryDtoFromJson(json);

  static const toJsonFactory = _$TransactionSummaryDtoToJson;
  Map<String, dynamic> toJson() => _$TransactionSummaryDtoToJson(this);

  @JsonKey(name: 'income')
  final double income;
  @JsonKey(name: 'expense')
  final double expense;
  @JsonKey(name: 'balance')
  final double balance;
  static const fromJsonFactory = _$TransactionSummaryDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TransactionSummaryDto &&
            (identical(other.income, income) ||
                const DeepCollectionEquality().equals(other.income, income)) &&
            (identical(other.expense, expense) ||
                const DeepCollectionEquality().equals(
                  other.expense,
                  expense,
                )) &&
            (identical(other.balance, balance) ||
                const DeepCollectionEquality().equals(other.balance, balance)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(income) ^
      const DeepCollectionEquality().hash(expense) ^
      const DeepCollectionEquality().hash(balance) ^
      runtimeType.hashCode;
}

extension $TransactionSummaryDtoExtension on TransactionSummaryDto {
  TransactionSummaryDto copyWith({
    double? income,
    double? expense,
    double? balance,
  }) {
    return TransactionSummaryDto(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      balance: balance ?? this.balance,
    );
  }

  TransactionSummaryDto copyWithWrapped({
    Wrapped<double>? income,
    Wrapped<double>? expense,
    Wrapped<double>? balance,
  }) {
    return TransactionSummaryDto(
      income: (income != null ? income.value : this.income),
      expense: (expense != null ? expense.value : this.expense),
      balance: (balance != null ? balance.value : this.balance),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class YearlyStatsResponseDto {
  const YearlyStatsResponseDto({
    required this.year,
    required this.transactions,
    required this.summary,
  });

  factory YearlyStatsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$YearlyStatsResponseDtoFromJson(json);

  static const toJsonFactory = _$YearlyStatsResponseDtoToJson;
  Map<String, dynamic> toJson() => _$YearlyStatsResponseDtoToJson(this);

  @JsonKey(name: 'year')
  final String year;
  @JsonKey(name: 'transactions', defaultValue: <TransactionResponseDto>[])
  final List<TransactionResponseDto> transactions;
  @JsonKey(name: 'summary')
  final TransactionSummaryDto summary;
  static const fromJsonFactory = _$YearlyStatsResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is YearlyStatsResponseDto &&
            (identical(other.year, year) ||
                const DeepCollectionEquality().equals(other.year, year)) &&
            (identical(other.transactions, transactions) ||
                const DeepCollectionEquality().equals(
                  other.transactions,
                  transactions,
                )) &&
            (identical(other.summary, summary) ||
                const DeepCollectionEquality().equals(other.summary, summary)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(year) ^
      const DeepCollectionEquality().hash(transactions) ^
      const DeepCollectionEquality().hash(summary) ^
      runtimeType.hashCode;
}

extension $YearlyStatsResponseDtoExtension on YearlyStatsResponseDto {
  YearlyStatsResponseDto copyWith({
    String? year,
    List<TransactionResponseDto>? transactions,
    TransactionSummaryDto? summary,
  }) {
    return YearlyStatsResponseDto(
      year: year ?? this.year,
      transactions: transactions ?? this.transactions,
      summary: summary ?? this.summary,
    );
  }

  YearlyStatsResponseDto copyWithWrapped({
    Wrapped<String>? year,
    Wrapped<List<TransactionResponseDto>>? transactions,
    Wrapped<TransactionSummaryDto>? summary,
  }) {
    return YearlyStatsResponseDto(
      year: (year != null ? year.value : this.year),
      transactions: (transactions != null
          ? transactions.value
          : this.transactions),
      summary: (summary != null ? summary.value : this.summary),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ScheduleResponseDto {
  const ScheduleResponseDto({
    required this.id,
    required this.date,
    this.description,
    required this.money,
    required this.catId,
    required this.icon,
    required this.name,
    required this.isIncome,
    required this.option,
    required this.userId,
  });

  factory ScheduleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseDtoFromJson(json);

  static const toJsonFactory = _$ScheduleResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ScheduleResponseDtoToJson(this);

  @JsonKey(name: 'id')
  final double id;
  @JsonKey(name: 'date')
  final String date;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'money')
  final double money;
  @JsonKey(name: 'catId')
  final String catId;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'isIncome')
  final bool isIncome;
  @JsonKey(
    name: 'option',
    toJson: scheduleResponseDtoOptionToJson,
    fromJson: scheduleResponseDtoOptionFromJson,
  )
  final enums.ScheduleResponseDtoOption option;
  @JsonKey(name: 'userId')
  final String userId;
  static const fromJsonFactory = _$ScheduleResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ScheduleResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.money, money) ||
                const DeepCollectionEquality().equals(other.money, money)) &&
            (identical(other.catId, catId) ||
                const DeepCollectionEquality().equals(other.catId, catId)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.option, option) ||
                const DeepCollectionEquality().equals(other.option, option)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(money) ^
      const DeepCollectionEquality().hash(catId) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(option) ^
      const DeepCollectionEquality().hash(userId) ^
      runtimeType.hashCode;
}

extension $ScheduleResponseDtoExtension on ScheduleResponseDto {
  ScheduleResponseDto copyWith({
    double? id,
    String? date,
    String? description,
    double? money,
    String? catId,
    String? icon,
    String? name,
    bool? isIncome,
    enums.ScheduleResponseDtoOption? option,
    String? userId,
  }) {
    return ScheduleResponseDto(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      money: money ?? this.money,
      catId: catId ?? this.catId,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
      option: option ?? this.option,
      userId: userId ?? this.userId,
    );
  }

  ScheduleResponseDto copyWithWrapped({
    Wrapped<double>? id,
    Wrapped<String>? date,
    Wrapped<String?>? description,
    Wrapped<double>? money,
    Wrapped<String>? catId,
    Wrapped<String>? icon,
    Wrapped<String>? name,
    Wrapped<bool>? isIncome,
    Wrapped<enums.ScheduleResponseDtoOption>? option,
    Wrapped<String>? userId,
  }) {
    return ScheduleResponseDto(
      id: (id != null ? id.value : this.id),
      date: (date != null ? date.value : this.date),
      description: (description != null ? description.value : this.description),
      money: (money != null ? money.value : this.money),
      catId: (catId != null ? catId.value : this.catId),
      icon: (icon != null ? icon.value : this.icon),
      name: (name != null ? name.value : this.name),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      option: (option != null ? option.value : this.option),
      userId: (userId != null ? userId.value : this.userId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateScheduleDto {
  const CreateScheduleDto({
    required this.date,
    this.description,
    required this.money,
    required this.catId,
    required this.icon,
    required this.name,
    required this.isIncome,
    required this.option,
  });

  factory CreateScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateScheduleDtoFromJson(json);

  static const toJsonFactory = _$CreateScheduleDtoToJson;
  Map<String, dynamic> toJson() => _$CreateScheduleDtoToJson(this);

  @JsonKey(name: 'date')
  final String date;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'money')
  final double money;
  @JsonKey(name: 'catId')
  final String catId;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'isIncome')
  final bool isIncome;
  @JsonKey(
    name: 'option',
    toJson: createScheduleDtoOptionToJson,
    fromJson: createScheduleDtoOptionFromJson,
  )
  final enums.CreateScheduleDtoOption option;
  static const fromJsonFactory = _$CreateScheduleDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateScheduleDto &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.money, money) ||
                const DeepCollectionEquality().equals(other.money, money)) &&
            (identical(other.catId, catId) ||
                const DeepCollectionEquality().equals(other.catId, catId)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.isIncome, isIncome) ||
                const DeepCollectionEquality().equals(
                  other.isIncome,
                  isIncome,
                )) &&
            (identical(other.option, option) ||
                const DeepCollectionEquality().equals(other.option, option)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(money) ^
      const DeepCollectionEquality().hash(catId) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(isIncome) ^
      const DeepCollectionEquality().hash(option) ^
      runtimeType.hashCode;
}

extension $CreateScheduleDtoExtension on CreateScheduleDto {
  CreateScheduleDto copyWith({
    String? date,
    String? description,
    double? money,
    String? catId,
    String? icon,
    String? name,
    bool? isIncome,
    enums.CreateScheduleDtoOption? option,
  }) {
    return CreateScheduleDto(
      date: date ?? this.date,
      description: description ?? this.description,
      money: money ?? this.money,
      catId: catId ?? this.catId,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
      option: option ?? this.option,
    );
  }

  CreateScheduleDto copyWithWrapped({
    Wrapped<String>? date,
    Wrapped<String?>? description,
    Wrapped<double>? money,
    Wrapped<String>? catId,
    Wrapped<String>? icon,
    Wrapped<String>? name,
    Wrapped<bool>? isIncome,
    Wrapped<enums.CreateScheduleDtoOption>? option,
  }) {
    return CreateScheduleDto(
      date: (date != null ? date.value : this.date),
      description: (description != null ? description.value : this.description),
      money: (money != null ? money.value : this.money),
      catId: (catId != null ? catId.value : this.catId),
      icon: (icon != null ? icon.value : this.icon),
      name: (name != null ? name.value : this.name),
      isIncome: (isIncome != null ? isIncome.value : this.isIncome),
      option: (option != null ? option.value : this.option),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiUsersMeAvatarPatch$RequestBody {
  const ApiUsersMeAvatarPatch$RequestBody({this.file});

  factory ApiUsersMeAvatarPatch$RequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$ApiUsersMeAvatarPatch$RequestBodyFromJson(json);

  static const toJsonFactory = _$ApiUsersMeAvatarPatch$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$ApiUsersMeAvatarPatch$RequestBodyToJson(this);

  @JsonKey(name: 'file')
  final String? file;
  static const fromJsonFactory = _$ApiUsersMeAvatarPatch$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiUsersMeAvatarPatch$RequestBody &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(file) ^ runtimeType.hashCode;
}

extension $ApiUsersMeAvatarPatch$RequestBodyExtension
    on ApiUsersMeAvatarPatch$RequestBody {
  ApiUsersMeAvatarPatch$RequestBody copyWith({String? file}) {
    return ApiUsersMeAvatarPatch$RequestBody(file: file ?? this.file);
  }

  ApiUsersMeAvatarPatch$RequestBody copyWithWrapped({Wrapped<String?>? file}) {
    return ApiUsersMeAvatarPatch$RequestBody(
      file: (file != null ? file.value : this.file),
    );
  }
}

String? categoryResponseDtoLimitTypeNullableToJson(
  enums.CategoryResponseDtoLimitType? categoryResponseDtoLimitType,
) {
  return categoryResponseDtoLimitType?.value;
}

String? categoryResponseDtoLimitTypeToJson(
  enums.CategoryResponseDtoLimitType categoryResponseDtoLimitType,
) {
  return categoryResponseDtoLimitType.value;
}

enums.CategoryResponseDtoLimitType categoryResponseDtoLimitTypeFromJson(
  Object? categoryResponseDtoLimitType, [
  enums.CategoryResponseDtoLimitType? defaultValue,
]) {
  return enums.CategoryResponseDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == categoryResponseDtoLimitType,
      ) ??
      defaultValue ??
      enums.CategoryResponseDtoLimitType.swaggerGeneratedUnknown;
}

enums.CategoryResponseDtoLimitType?
categoryResponseDtoLimitTypeNullableFromJson(
  Object? categoryResponseDtoLimitType, [
  enums.CategoryResponseDtoLimitType? defaultValue,
]) {
  if (categoryResponseDtoLimitType == null) {
    return null;
  }
  return enums.CategoryResponseDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == categoryResponseDtoLimitType,
      ) ??
      defaultValue;
}

String categoryResponseDtoLimitTypeExplodedListToJson(
  List<enums.CategoryResponseDtoLimitType>? categoryResponseDtoLimitType,
) {
  return categoryResponseDtoLimitType?.map((e) => e.value!).join(',') ?? '';
}

List<String> categoryResponseDtoLimitTypeListToJson(
  List<enums.CategoryResponseDtoLimitType>? categoryResponseDtoLimitType,
) {
  if (categoryResponseDtoLimitType == null) {
    return [];
  }

  return categoryResponseDtoLimitType.map((e) => e.value!).toList();
}

List<enums.CategoryResponseDtoLimitType>
categoryResponseDtoLimitTypeListFromJson(
  List? categoryResponseDtoLimitType, [
  List<enums.CategoryResponseDtoLimitType>? defaultValue,
]) {
  if (categoryResponseDtoLimitType == null) {
    return defaultValue ?? [];
  }

  return categoryResponseDtoLimitType
      .map((e) => categoryResponseDtoLimitTypeFromJson(e.toString()))
      .toList();
}

List<enums.CategoryResponseDtoLimitType>?
categoryResponseDtoLimitTypeNullableListFromJson(
  List? categoryResponseDtoLimitType, [
  List<enums.CategoryResponseDtoLimitType>? defaultValue,
]) {
  if (categoryResponseDtoLimitType == null) {
    return defaultValue;
  }

  return categoryResponseDtoLimitType
      .map((e) => categoryResponseDtoLimitTypeFromJson(e.toString()))
      .toList();
}

String? createCategoryDtoLimitTypeNullableToJson(
  enums.CreateCategoryDtoLimitType? createCategoryDtoLimitType,
) {
  return createCategoryDtoLimitType?.value;
}

String? createCategoryDtoLimitTypeToJson(
  enums.CreateCategoryDtoLimitType createCategoryDtoLimitType,
) {
  return createCategoryDtoLimitType.value;
}

enums.CreateCategoryDtoLimitType createCategoryDtoLimitTypeFromJson(
  Object? createCategoryDtoLimitType, [
  enums.CreateCategoryDtoLimitType? defaultValue,
]) {
  return enums.CreateCategoryDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == createCategoryDtoLimitType,
      ) ??
      defaultValue ??
      enums.CreateCategoryDtoLimitType.swaggerGeneratedUnknown;
}

enums.CreateCategoryDtoLimitType? createCategoryDtoLimitTypeNullableFromJson(
  Object? createCategoryDtoLimitType, [
  enums.CreateCategoryDtoLimitType? defaultValue,
]) {
  if (createCategoryDtoLimitType == null) {
    return null;
  }
  return enums.CreateCategoryDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == createCategoryDtoLimitType,
      ) ??
      defaultValue;
}

String createCategoryDtoLimitTypeExplodedListToJson(
  List<enums.CreateCategoryDtoLimitType>? createCategoryDtoLimitType,
) {
  return createCategoryDtoLimitType?.map((e) => e.value!).join(',') ?? '';
}

List<String> createCategoryDtoLimitTypeListToJson(
  List<enums.CreateCategoryDtoLimitType>? createCategoryDtoLimitType,
) {
  if (createCategoryDtoLimitType == null) {
    return [];
  }

  return createCategoryDtoLimitType.map((e) => e.value!).toList();
}

List<enums.CreateCategoryDtoLimitType> createCategoryDtoLimitTypeListFromJson(
  List? createCategoryDtoLimitType, [
  List<enums.CreateCategoryDtoLimitType>? defaultValue,
]) {
  if (createCategoryDtoLimitType == null) {
    return defaultValue ?? [];
  }

  return createCategoryDtoLimitType
      .map((e) => createCategoryDtoLimitTypeFromJson(e.toString()))
      .toList();
}

List<enums.CreateCategoryDtoLimitType>?
createCategoryDtoLimitTypeNullableListFromJson(
  List? createCategoryDtoLimitType, [
  List<enums.CreateCategoryDtoLimitType>? defaultValue,
]) {
  if (createCategoryDtoLimitType == null) {
    return defaultValue;
  }

  return createCategoryDtoLimitType
      .map((e) => createCategoryDtoLimitTypeFromJson(e.toString()))
      .toList();
}

String? updateCategoryDtoLimitTypeNullableToJson(
  enums.UpdateCategoryDtoLimitType? updateCategoryDtoLimitType,
) {
  return updateCategoryDtoLimitType?.value;
}

String? updateCategoryDtoLimitTypeToJson(
  enums.UpdateCategoryDtoLimitType updateCategoryDtoLimitType,
) {
  return updateCategoryDtoLimitType.value;
}

enums.UpdateCategoryDtoLimitType updateCategoryDtoLimitTypeFromJson(
  Object? updateCategoryDtoLimitType, [
  enums.UpdateCategoryDtoLimitType? defaultValue,
]) {
  return enums.UpdateCategoryDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == updateCategoryDtoLimitType,
      ) ??
      defaultValue ??
      enums.UpdateCategoryDtoLimitType.swaggerGeneratedUnknown;
}

enums.UpdateCategoryDtoLimitType? updateCategoryDtoLimitTypeNullableFromJson(
  Object? updateCategoryDtoLimitType, [
  enums.UpdateCategoryDtoLimitType? defaultValue,
]) {
  if (updateCategoryDtoLimitType == null) {
    return null;
  }
  return enums.UpdateCategoryDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == updateCategoryDtoLimitType,
      ) ??
      defaultValue;
}

String updateCategoryDtoLimitTypeExplodedListToJson(
  List<enums.UpdateCategoryDtoLimitType>? updateCategoryDtoLimitType,
) {
  return updateCategoryDtoLimitType?.map((e) => e.value!).join(',') ?? '';
}

List<String> updateCategoryDtoLimitTypeListToJson(
  List<enums.UpdateCategoryDtoLimitType>? updateCategoryDtoLimitType,
) {
  if (updateCategoryDtoLimitType == null) {
    return [];
  }

  return updateCategoryDtoLimitType.map((e) => e.value!).toList();
}

List<enums.UpdateCategoryDtoLimitType> updateCategoryDtoLimitTypeListFromJson(
  List? updateCategoryDtoLimitType, [
  List<enums.UpdateCategoryDtoLimitType>? defaultValue,
]) {
  if (updateCategoryDtoLimitType == null) {
    return defaultValue ?? [];
  }

  return updateCategoryDtoLimitType
      .map((e) => updateCategoryDtoLimitTypeFromJson(e.toString()))
      .toList();
}

List<enums.UpdateCategoryDtoLimitType>?
updateCategoryDtoLimitTypeNullableListFromJson(
  List? updateCategoryDtoLimitType, [
  List<enums.UpdateCategoryDtoLimitType>? defaultValue,
]) {
  if (updateCategoryDtoLimitType == null) {
    return defaultValue;
  }

  return updateCategoryDtoLimitType
      .map((e) => updateCategoryDtoLimitTypeFromJson(e.toString()))
      .toList();
}

String? updateLimitDtoLimitTypeNullableToJson(
  enums.UpdateLimitDtoLimitType? updateLimitDtoLimitType,
) {
  return updateLimitDtoLimitType?.value;
}

String? updateLimitDtoLimitTypeToJson(
  enums.UpdateLimitDtoLimitType updateLimitDtoLimitType,
) {
  return updateLimitDtoLimitType.value;
}

enums.UpdateLimitDtoLimitType updateLimitDtoLimitTypeFromJson(
  Object? updateLimitDtoLimitType, [
  enums.UpdateLimitDtoLimitType? defaultValue,
]) {
  return enums.UpdateLimitDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == updateLimitDtoLimitType,
      ) ??
      defaultValue ??
      enums.UpdateLimitDtoLimitType.swaggerGeneratedUnknown;
}

enums.UpdateLimitDtoLimitType? updateLimitDtoLimitTypeNullableFromJson(
  Object? updateLimitDtoLimitType, [
  enums.UpdateLimitDtoLimitType? defaultValue,
]) {
  if (updateLimitDtoLimitType == null) {
    return null;
  }
  return enums.UpdateLimitDtoLimitType.values.firstWhereOrNull(
        (e) => e.value == updateLimitDtoLimitType,
      ) ??
      defaultValue;
}

String updateLimitDtoLimitTypeExplodedListToJson(
  List<enums.UpdateLimitDtoLimitType>? updateLimitDtoLimitType,
) {
  return updateLimitDtoLimitType?.map((e) => e.value!).join(',') ?? '';
}

List<String> updateLimitDtoLimitTypeListToJson(
  List<enums.UpdateLimitDtoLimitType>? updateLimitDtoLimitType,
) {
  if (updateLimitDtoLimitType == null) {
    return [];
  }

  return updateLimitDtoLimitType.map((e) => e.value!).toList();
}

List<enums.UpdateLimitDtoLimitType> updateLimitDtoLimitTypeListFromJson(
  List? updateLimitDtoLimitType, [
  List<enums.UpdateLimitDtoLimitType>? defaultValue,
]) {
  if (updateLimitDtoLimitType == null) {
    return defaultValue ?? [];
  }

  return updateLimitDtoLimitType
      .map((e) => updateLimitDtoLimitTypeFromJson(e.toString()))
      .toList();
}

List<enums.UpdateLimitDtoLimitType>?
updateLimitDtoLimitTypeNullableListFromJson(
  List? updateLimitDtoLimitType, [
  List<enums.UpdateLimitDtoLimitType>? defaultValue,
]) {
  if (updateLimitDtoLimitType == null) {
    return defaultValue;
  }

  return updateLimitDtoLimitType
      .map((e) => updateLimitDtoLimitTypeFromJson(e.toString()))
      .toList();
}

String? scheduleResponseDtoOptionNullableToJson(
  enums.ScheduleResponseDtoOption? scheduleResponseDtoOption,
) {
  return scheduleResponseDtoOption?.value;
}

String? scheduleResponseDtoOptionToJson(
  enums.ScheduleResponseDtoOption scheduleResponseDtoOption,
) {
  return scheduleResponseDtoOption.value;
}

enums.ScheduleResponseDtoOption scheduleResponseDtoOptionFromJson(
  Object? scheduleResponseDtoOption, [
  enums.ScheduleResponseDtoOption? defaultValue,
]) {
  return enums.ScheduleResponseDtoOption.values.firstWhereOrNull(
        (e) => e.value == scheduleResponseDtoOption,
      ) ??
      defaultValue ??
      enums.ScheduleResponseDtoOption.swaggerGeneratedUnknown;
}

enums.ScheduleResponseDtoOption? scheduleResponseDtoOptionNullableFromJson(
  Object? scheduleResponseDtoOption, [
  enums.ScheduleResponseDtoOption? defaultValue,
]) {
  if (scheduleResponseDtoOption == null) {
    return null;
  }
  return enums.ScheduleResponseDtoOption.values.firstWhereOrNull(
        (e) => e.value == scheduleResponseDtoOption,
      ) ??
      defaultValue;
}

String scheduleResponseDtoOptionExplodedListToJson(
  List<enums.ScheduleResponseDtoOption>? scheduleResponseDtoOption,
) {
  return scheduleResponseDtoOption?.map((e) => e.value!).join(',') ?? '';
}

List<String> scheduleResponseDtoOptionListToJson(
  List<enums.ScheduleResponseDtoOption>? scheduleResponseDtoOption,
) {
  if (scheduleResponseDtoOption == null) {
    return [];
  }

  return scheduleResponseDtoOption.map((e) => e.value!).toList();
}

List<enums.ScheduleResponseDtoOption> scheduleResponseDtoOptionListFromJson(
  List? scheduleResponseDtoOption, [
  List<enums.ScheduleResponseDtoOption>? defaultValue,
]) {
  if (scheduleResponseDtoOption == null) {
    return defaultValue ?? [];
  }

  return scheduleResponseDtoOption
      .map((e) => scheduleResponseDtoOptionFromJson(e.toString()))
      .toList();
}

List<enums.ScheduleResponseDtoOption>?
scheduleResponseDtoOptionNullableListFromJson(
  List? scheduleResponseDtoOption, [
  List<enums.ScheduleResponseDtoOption>? defaultValue,
]) {
  if (scheduleResponseDtoOption == null) {
    return defaultValue;
  }

  return scheduleResponseDtoOption
      .map((e) => scheduleResponseDtoOptionFromJson(e.toString()))
      .toList();
}

String? createScheduleDtoOptionNullableToJson(
  enums.CreateScheduleDtoOption? createScheduleDtoOption,
) {
  return createScheduleDtoOption?.value;
}

String? createScheduleDtoOptionToJson(
  enums.CreateScheduleDtoOption createScheduleDtoOption,
) {
  return createScheduleDtoOption.value;
}

enums.CreateScheduleDtoOption createScheduleDtoOptionFromJson(
  Object? createScheduleDtoOption, [
  enums.CreateScheduleDtoOption? defaultValue,
]) {
  return enums.CreateScheduleDtoOption.values.firstWhereOrNull(
        (e) => e.value == createScheduleDtoOption,
      ) ??
      defaultValue ??
      enums.CreateScheduleDtoOption.swaggerGeneratedUnknown;
}

enums.CreateScheduleDtoOption? createScheduleDtoOptionNullableFromJson(
  Object? createScheduleDtoOption, [
  enums.CreateScheduleDtoOption? defaultValue,
]) {
  if (createScheduleDtoOption == null) {
    return null;
  }
  return enums.CreateScheduleDtoOption.values.firstWhereOrNull(
        (e) => e.value == createScheduleDtoOption,
      ) ??
      defaultValue;
}

String createScheduleDtoOptionExplodedListToJson(
  List<enums.CreateScheduleDtoOption>? createScheduleDtoOption,
) {
  return createScheduleDtoOption?.map((e) => e.value!).join(',') ?? '';
}

List<String> createScheduleDtoOptionListToJson(
  List<enums.CreateScheduleDtoOption>? createScheduleDtoOption,
) {
  if (createScheduleDtoOption == null) {
    return [];
  }

  return createScheduleDtoOption.map((e) => e.value!).toList();
}

List<enums.CreateScheduleDtoOption> createScheduleDtoOptionListFromJson(
  List? createScheduleDtoOption, [
  List<enums.CreateScheduleDtoOption>? defaultValue,
]) {
  if (createScheduleDtoOption == null) {
    return defaultValue ?? [];
  }

  return createScheduleDtoOption
      .map((e) => createScheduleDtoOptionFromJson(e.toString()))
      .toList();
}

List<enums.CreateScheduleDtoOption>?
createScheduleDtoOptionNullableListFromJson(
  List? createScheduleDtoOption, [
  List<enums.CreateScheduleDtoOption>? defaultValue,
]) {
  if (createScheduleDtoOption == null) {
    return defaultValue;
  }

  return createScheduleDtoOption
      .map((e) => createScheduleDtoOptionFromJson(e.toString()))
      .toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
