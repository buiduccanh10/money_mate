import 'package:equatable/equatable.dart';

enum ChartStatus { initial, loading, success, failure }

class ChartState extends Equatable {
  final ChartStatus status;
  final List<Map<String, dynamic>> incomeData;
  final List<Map<String, dynamic>> expenseData;
  final List<Map<String, dynamic>> yearlyData;
  final List<Map<String, dynamic>> detailData;
  final bool isMonthly;
  final bool isIncome;
  final int month;
  final int year;
  final String? errorMessage;

  const ChartState({
    this.status = ChartStatus.initial,
    this.incomeData = const [],
    this.expenseData = const [],
    this.yearlyData = const [],
    this.detailData = const [],
    this.isMonthly = true,
    this.isIncome = false,
    required this.month,
    required this.year,
    this.errorMessage,
  });

  ChartState copyWith({
    ChartStatus? status,
    List<Map<String, dynamic>>? incomeData,
    List<Map<String, dynamic>>? expenseData,
    List<Map<String, dynamic>>? yearlyData,
    List<Map<String, dynamic>>? detailData,
    bool? isMonthly,
    bool? isIncome,
    int? month,
    int? year,
    String? errorMessage,
  }) {
    return ChartState(
      status: status ?? this.status,
      incomeData: incomeData ?? this.incomeData,
      expenseData: expenseData ?? this.expenseData,
      yearlyData: yearlyData ?? this.yearlyData,
      detailData: detailData ?? this.detailData,
      isMonthly: isMonthly ?? this.isMonthly,
      isIncome: isIncome ?? this.isIncome,
      month: month ?? this.month,
      year: year ?? this.year,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incomeData,
        expenseData,
        yearlyData,
        detailData,
        isMonthly,
        isIncome,
        month,
        year,
        errorMessage,
      ];
}
