import 'package:equatable/equatable.dart';

enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  final ScheduleStatus status;
  final List<Map<String, dynamic>> schedules;
  final String? errorMessage;

  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.schedules = const [],
    this.errorMessage,
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    List<Map<String, dynamic>>? schedules,
    String? errorMessage,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, schedules, errorMessage];
}
