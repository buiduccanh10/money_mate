import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final TransactionRepository _transactionRepo;

  ChartCubit({required TransactionRepository transactionRepo})
    : _transactionRepo = transactionRepo,
      super(
        ChartState(month: DateTime.now().month, year: DateTime.now().year),
      ) {
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

      final income = await _transactionRepo.getTransactions(
        monthYear: formatDate,
        isIncome: true,
      );
      final expense = await _transactionRepo.getTransactions(
        monthYear: formatDate,
        isIncome: false,
      );

      emit(
        state.copyWith(
          status: ChartStatus.success,
          incomeTransactions: income,
          expenseTransactions: expense,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ChartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> fetchYearlyData() async {
    emit(state.copyWith(status: ChartStatus.loading));
    try {
      final data = await _transactionRepo.getTransactions(
        year: state.year.toString(),
      );
      emit(state.copyWith(status: ChartStatus.success, allTransactions: data));
    } catch (e) {
      emit(
        state.copyWith(status: ChartStatus.failure, errorMessage: e.toString()),
      );
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
    emit(
      state.copyWith(
        status: ChartStatus.loading,
        lastDetailIsMonthly: isMonthly,
        lastDetailIsIncome: isIncome,
        lastDetailDate: date,
        lastDetailCatId: catId,
      ),
    );
    try {
      final data = await _transactionRepo.getTransactions(
        monthYear: isMonthly ? date : null,
        year: !isMonthly ? date : null,
        isIncome: isIncome,
        catId: catId,
      );
      emit(state.copyWith(status: ChartStatus.success, detailData: data));
    } catch (e) {
      emit(
        state.copyWith(status: ChartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> refreshDetail() async {
    if (state.lastDetailIsMonthly != null) {
      await fetchDetail(
        isMonthly: state.lastDetailIsMonthly!,
        isIncome: state.lastDetailIsIncome,
        date: state.lastDetailDate,
        catId: state.lastDetailCatId,
      );
    }
  }
}
