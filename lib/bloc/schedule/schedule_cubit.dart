import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/schedule_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _scheduleRepo;

  ScheduleCubit({required ScheduleRepository scheduleRepo})
      : _scheduleRepo = scheduleRepo,
        super(const ScheduleState()) {
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final data = await _scheduleRepo.getSchedules();
      emit(state.copyWith(status: ScheduleStatus.success, schedules: data));
    } catch (e) {
      emit(state.copyWith(
          status: ScheduleStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> addSchedule(Map<String, dynamic> data) async {
    try {
      await _scheduleRepo.addSchedule(data);
      fetchSchedules();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteSchedule(int id) async {
    try {
      await _scheduleRepo.deleteSchedule(id);
      fetchSchedules();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteAllSchedules() async {
    try {
      await _scheduleRepo.deleteAllSchedules();
      fetchSchedules();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
