import 'package:equatable/equatable.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

enum ChartStatus { initial, loading, success, failure }

class ChartState extends Equatable {
  final ChartStatus status;
  final List<TransactionResponseDto> incomeTransactions; // For aggregate
  final List<TransactionResponseDto> expenseTransactions;
  final List<TransactionResponseDto> allTransactions;
  final List<TransactionResponseDto> detailData;
  final bool isMonthly;
  final bool isIncome;
  final int month;
  final int year;
  final String? errorMessage;

  const ChartState({
    this.status = ChartStatus.initial,
    this.incomeTransactions = const [],
    this.expenseTransactions = const [],
    this.allTransactions = const [],
    this.detailData = const [],
    this.isMonthly = true,
    this.isIncome = false,
    required this.month,
    required this.year,
    this.errorMessage,
  });

  ChartState copyWith({
    ChartStatus? status,
    List<TransactionResponseDto>? incomeTransactions,
    List<TransactionResponseDto>? expenseTransactions,
    List<TransactionResponseDto>? allTransactions,
    List<TransactionResponseDto>? detailData,
    bool? isMonthly,
    bool? isIncome,
    int? month,
    int? year,
    String? errorMessage,
  }) {
    return ChartState(
      status: status ?? this.status,
      incomeTransactions: incomeTransactions ?? this.incomeTransactions,
      expenseTransactions: expenseTransactions ?? this.expenseTransactions,
      allTransactions: allTransactions ?? this.allTransactions,
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
    incomeTransactions,
    expenseTransactions,
    allTransactions,
    detailData,
    isMonthly,
    isIncome,
    month,
    year,
    errorMessage,
  ];
}
