import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/data/repository/schedule_repository.dart';

class ScheduleService {
  final TransactionRepository _transactionRepo;
  final ScheduleRepository _scheduleRepo;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ScheduleService({
    required TransactionRepository transactionRepo,
    required ScheduleRepository scheduleRepo,
  }) : _transactionRepo = transactionRepo,
       _scheduleRepo = scheduleRepo;

  Future<void> runCronJob() async {
    try {
      final schedules = await _scheduleRepo.getSchedules();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Get last execution data: Map<scheduleId, lastExecutionDateString>
      final String? lastExecJson = await _storage.read(
        key: 'schedules_last_exec',
      );
      Map<String, dynamic> lastExecMap = {};
      if (lastExecJson != null) {
        lastExecMap = jsonDecode(lastExecJson);
      }

      bool hasChanges = false;

      for (var schedule in schedules) {
        final String scheduleId = schedule.id.toString();

        // Parse start date/time of the schedule
        DateTime? scheduleDateTime = _parseDate(schedule.date);
        if (scheduleDateTime == null) continue;

        // Extract the time component from the original schedule
        final String scheduledTime = DateFormat(
          'HH:mm',
        ).format(scheduleDateTime);

        // Start from the base date (ignore time for the currentExecDate iteration)
        DateTime currentExecDate = DateTime(
          scheduleDateTime.year,
          scheduleDateTime.month,
          scheduleDateTime.day,
        );

        // If we have a last execution date, start from the day after that
        if (lastExecMap.containsKey(scheduleId)) {
          DateTime? lastDate = _parseDate(lastExecMap[scheduleId]);
          if (lastDate != null) {
            currentExecDate = _getNextDate(lastDate, schedule.option);
          }
        }

        // Keep creating transactions until the next scheduled date is in the future
        while (currentExecDate.isBefore(today) ||
            currentExecDate.isAtSameMomentAs(today)) {
          await _transactionRepo.addTransaction(
            DateFormat('yyyy-MM-dd').format(currentExecDate),
            scheduledTime, // Use the time from the setup
            schedule.description ?? schedule.name,
            schedule.money,
            schedule.catId,
            schedule.isIncome,
          );

          lastExecMap[scheduleId] = DateFormat(
            'yyyy-MM-dd',
          ).format(currentExecDate);
          currentExecDate = _getNextDate(currentExecDate, schedule.option);
          hasChanges = true;
        }
      }

      if (hasChanges) {
        await _storage.write(
          key: 'schedules_last_exec',
          value: jsonEncode(lastExecMap),
        );
      }
    } catch (e) {
      print('Error running cron job: $e');
    }
  }

  DateTime _getNextDate(DateTime date, ScheduleResponseDtoOption option) {
    switch (option) {
      case ScheduleResponseDtoOption.daily:
        return date.add(const Duration(days: 1));
      case ScheduleResponseDtoOption.weekly:
        return date.add(const Duration(days: 7));
      case ScheduleResponseDtoOption.monthly:
        return DateTime(date.year, date.month + 1, date.day);
      case ScheduleResponseDtoOption.yearly:
        return DateTime(date.year + 1, date.month, date.day);
      default:
        return date.add(const Duration(days: 1));
    }
  }

  DateTime? _parseDate(String dateStr) {
    // Try ISO8601 (from new StartSetup)
    DateTime? dt = DateTime.tryParse(dateStr);
    if (dt != null) return dt;

    // Try dd/MM/yyyy (old StartSetup)
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (_) {}

    // Try yyyy-MM-dd (lastExec format)
    try {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    } catch (_) {}

    return null;
  }
}
