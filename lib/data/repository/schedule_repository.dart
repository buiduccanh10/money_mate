import 'package:dio/dio.dart';
import 'package:money_mate/data/network/dio_client.dart';

abstract class ScheduleRepository {
  Future<List<Map<String, dynamic>>> getSchedules();
  Future<void> addSchedule(Map<String, dynamic> data);
  Future<void> deleteSchedule(int id);
  Future<void> deleteAllSchedules();
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Map<String, dynamic>>> getSchedules() async {
    try {
      final response = await _dio.get('/schedules');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSchedule(Map<String, dynamic> data) async {
    try {
      await _dio.post('/schedules', data: data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(int id) async {
    try {
      await _dio.delete('/schedules/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllSchedules() async {
    try {
      await _dio.delete('/schedules');
    } catch (e) {
      rethrow;
    }
  }
}
