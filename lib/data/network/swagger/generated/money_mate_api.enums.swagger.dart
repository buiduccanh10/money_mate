// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum CategoryResponseDtoLimitType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('DAILY')
  daily('DAILY'),
  @JsonValue('WEEKLY')
  weekly('WEEKLY'),
  @JsonValue('MONTHLY')
  monthly('MONTHLY'),
  @JsonValue('YEARLY')
  yearly('YEARLY');

  final String? value;

  const CategoryResponseDtoLimitType(this.value);
}

enum CreateCategoryDtoLimitType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('DAILY')
  daily('DAILY'),
  @JsonValue('WEEKLY')
  weekly('WEEKLY'),
  @JsonValue('MONTHLY')
  monthly('MONTHLY'),
  @JsonValue('YEARLY')
  yearly('YEARLY');

  final String? value;

  const CreateCategoryDtoLimitType(this.value);
}

enum UpdateCategoryDtoLimitType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('DAILY')
  daily('DAILY'),
  @JsonValue('WEEKLY')
  weekly('WEEKLY'),
  @JsonValue('MONTHLY')
  monthly('MONTHLY'),
  @JsonValue('YEARLY')
  yearly('YEARLY');

  final String? value;

  const UpdateCategoryDtoLimitType(this.value);
}

enum UpdateLimitDtoLimitType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('DAILY')
  daily('DAILY'),
  @JsonValue('WEEKLY')
  weekly('WEEKLY'),
  @JsonValue('MONTHLY')
  monthly('MONTHLY'),
  @JsonValue('YEARLY')
  yearly('YEARLY');

  final String? value;

  const UpdateLimitDtoLimitType(this.value);
}

enum ScheduleResponseDtoOption {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('DAILY')
  daily('DAILY'),
  @JsonValue('WEEKLY')
  weekly('WEEKLY'),
  @JsonValue('MONTHLY')
  monthly('MONTHLY'),
  @JsonValue('YEARLY')
  yearly('YEARLY');

  final String? value;

  const ScheduleResponseDtoOption(this.value);
}

enum CreateScheduleDtoOption {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Never')
  never('Never'),
  @JsonValue('Daily')
  daily('Daily'),
  @JsonValue('Weekly')
  weekly('Weekly'),
  @JsonValue('Monthly')
  monthly('Monthly'),
  @JsonValue('Yearly')
  yearly('Yearly');

  final String? value;

  const CreateScheduleDtoOption(this.value);
}

enum UpdateScheduleDtoOption {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Never')
  never('Never'),
  @JsonValue('Daily')
  daily('Daily'),
  @JsonValue('Weekly')
  weekly('Weekly'),
  @JsonValue('Monthly')
  monthly('Monthly'),
  @JsonValue('Yearly')
  yearly('Yearly');

  final String? value;

  const UpdateScheduleDtoOption(this.value);
}
