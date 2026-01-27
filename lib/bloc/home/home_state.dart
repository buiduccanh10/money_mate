import 'package:equatable/equatable.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final int month;
  final int year;
  final String formattedDate;
  final List<TransactionResponseDto> incomeTransactions;
  final List<TransactionResponseDto> expenseTransactions;
  final List<TransactionResponseDto> allTransactions;
  final double totalIncome;
  final double totalExpense;
  final double totalSaving;
  final String? userName;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    required this.month,
    required this.year,
    this.formattedDate = '',
    this.incomeTransactions = const [],
    this.expenseTransactions = const [],
    this.allTransactions = const [],
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.totalSaving = 0,
    this.userName,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    int? month,
    int? year,
    String? formattedDate,
    List<TransactionResponseDto>? incomeTransactions,
    List<TransactionResponseDto>? expenseTransactions,
    List<TransactionResponseDto>? allTransactions,
    double? totalIncome,
    double? totalExpense,
    double? totalSaving,
    String? userName,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      month: month ?? this.month,
      year: year ?? this.year,
      formattedDate: formattedDate ?? this.formattedDate,
      incomeTransactions: incomeTransactions ?? this.incomeTransactions,
      expenseTransactions: expenseTransactions ?? this.expenseTransactions,
      allTransactions: allTransactions ?? this.allTransactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      totalSaving: totalSaving ?? this.totalSaving,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        month,
        year,
        formattedDate,
        incomeTransactions,
        expenseTransactions,
        allTransactions,
        totalIncome,
        totalExpense,
        totalSaving,
        userName,
        errorMessage,
      ];
}
