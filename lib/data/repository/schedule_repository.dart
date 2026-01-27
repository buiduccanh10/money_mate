import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleResponseDto>> getSchedules();
  Future<ScheduleResponseDto> addSchedule({
    required String date,
    required String description,
    required double money,
    required String catId,
    required String icon,
    required String name,
    required bool isIncome,
    required CreateScheduleDtoOption option,
  });
  Future<void> deleteSchedule(String id);
  Future<void> deleteAllSchedules();
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final _api = ApiClient.api;

  @override
  Future<List<ScheduleResponseDto>> getSchedules() async {
    final response = await _api.apiSchedulesGet();
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to fetch schedules');
    }
  }

  @override
  Future<ScheduleResponseDto> addSchedule({
    required String date,
    required String description,
    required double money,
    required String catId,
    required String icon,
    required String name,
    required bool isIncome,
    required CreateScheduleDtoOption option,
  }) async {
    final response = await _api.apiSchedulesPost(
      body: CreateScheduleDto(
        date: date,
        description: description,
        money: money,
        catId: catId,
        icon: icon,
        name: name,
        isIncome: isIncome,
        option: option,
      ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to create schedule');
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    final response = await _api.apiSchedulesIdDelete(id: double.parse(id));
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete schedule');
    }
  }

  @override
  Future<void> deleteAllSchedules() async {
    final response = await _api.apiSchedulesDelete();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete all schedules');
    }
  }
}
