import 'package:equatable/equatable.dart';

enum SettingStatus { initial, loading, success, failure }

class SettingState extends Equatable {
  final SettingStatus status;
  final bool isDark;
  final bool isLock;
  final String language;
  final String? userName;
  final String? email;
  final String? image;
  final String? errorMessage;

  const SettingState({
    this.status = SettingStatus.initial,
    this.isDark = false,
    this.isLock = false,
    this.language = 'en',
    this.userName,
    this.email,
    this.image,
    this.errorMessage,
  });

  SettingState copyWith({
    SettingStatus? status,
    bool? isDark,
    bool? isLock,
    String? language,
    String? userName,
    String? email,
    String? image,
    String? errorMessage,
  }) {
    return SettingState(
      status: status ?? this.status,
      isDark: isDark ?? this.isDark,
      isLock: isLock ?? this.isLock,
      language: language ?? this.language,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isDark,
    isLock,
    language,
    userName,
    email,
    image,
    errorMessage,
  ];
}
