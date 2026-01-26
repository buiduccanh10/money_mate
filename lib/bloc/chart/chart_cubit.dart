import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/network/dio_client.dart';
import 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  // Directly using Dio for now as there might not be a specific chart repo yet
  final _dio = DioClient().dio;

  ChartCubit()
      : super(ChartState(
          month: DateTime.now().month,
          year: DateTime.now().year,
        )) {
    fetchData();
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  Future<void> fetchData() async {
    if (state.isMonthly) {
      await fetchMonthlyData();
    } else {
      await fetchYearlyData();
    }
  }

  Future<void> fetchMonthlyData() async {
    emit(state.copyWith(status: ChartStatus.loading));
    try {
      String formatDate = getMonthYearString(state.month, state.year);

      final incomeRes = await _dio.get('/transactions', queryParameters: {
        'monthYear': formatDate,
        'isIncome': true,
      });
      final expenseRes = await _dio.get('/transactions', queryParameters: {
        'monthYear': formatDate,
        'isIncome': false,
      });

      emit(state.copyWith(
        status: ChartStatus.success,
        incomeData: List<Map<String, dynamic>>.from(incomeRes.data),
        expenseData: List<Map<String, dynamic>>.from(expenseRes.data),
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChartStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> fetchYearlyData() async {
    emit(state.copyWith(status: ChartStatus.loading));
    try {
      final res = await _dio.get('/transactions/yearly', queryParameters: {
        'year': state.year,
      });
      emit(state.copyWith(
        status: ChartStatus.success,
        yearlyData: List<Map<String, dynamic>>.from(res.data),
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChartStatus.failure, errorMessage: e.toString()));
    }
  }

  void toggleView(bool isMonthly) {
    emit(state.copyWith(isMonthly: isMonthly));
    fetchData();
  }

  void toggleIncome(bool isIncome) {
    emit(state.copyWith(isIncome: isIncome));
  }

  void changeMonth(int month) {
    emit(state.copyWith(month: month));
    if (state.isMonthly) fetchMonthlyData();
  }

  void changeYear(int year) {
    emit(state.copyWith(year: year));
    if (state.isMonthly) {
      fetchMonthlyData();
    } else {
      fetchYearlyData();
    }
  }

  Future<void> fetchDetail({
    required bool isMonthly,
    bool? isIncome,
    String? date,
    String? catId,
  }) async {
    emit(state.copyWith(status: ChartStatus.loading));
    try {
      final queryParams = <String, dynamic>{};
      if (isMonthly && date != null) queryParams['monthYear'] = date;
      if (!isMonthly && date != null) queryParams['year'] = date;
      if (isIncome != null) queryParams['isIncome'] = isIncome;
      if (catId != null) queryParams['catId'] = catId;

      final res = await _dio.get('/transactions', queryParameters: queryParams);
      emit(state.copyWith(
        status: ChartStatus.success,
        detailData: List<Map<String, dynamic>>.from(res.data),
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChartStatus.failure, errorMessage: e.toString()));
    }
  }
}
