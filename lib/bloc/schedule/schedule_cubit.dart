import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/schedule_repository.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
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
      emit(
        state.copyWith(
          status: ScheduleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addSchedule({
    required String date,
    required String description,
    required double money,
    required String catId,
    required String icon,
    required String name,
    required bool isIncome,
    required CreateScheduleDtoOption option,
  }) async {
    try {
      await _scheduleRepo.addSchedule(
        date: date,
        description: description,
        money: money,
        catId: catId,
        icon: icon,
        name: name,
        isIncome: isIncome,
        option: option,
      );
      fetchSchedules();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateSchedule({
    required String id,
    required String date,
    required String description,
    required double money,
    required String catId,
    required String icon,
    required String name,
    required bool isIncome,
    required CreateScheduleDtoOption option,
  }) async {
    try {
      await _scheduleRepo.updateSchedule(
        id: id,
        date: date,
        description: description,
        money: money,
        catId: catId,
        icon: icon,
        name: name,
        isIncome: isIncome,
        option: option,
      );
      fetchSchedules();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteSchedule(String id) async {
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
