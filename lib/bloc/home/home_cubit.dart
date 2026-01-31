import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/data/repository/user_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionRepository _transactionRepo;
  final UserRepository _userRepo;

  HomeCubit({
    required TransactionRepository transactionRepo,
    required UserRepository userRepo,
  }) : _transactionRepo = transactionRepo,
       _userRepo = userRepo,
       super(
         HomeState(month: DateTime.now().month, year: DateTime.now().year),
       ) {
    init();
  }

  void init() {
    final formattedDate = getMonthYearString(state.month, state.year);
    emit(state.copyWith(formattedDate: formattedDate));
    fetchData();
    fetchUserName();
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MM/yyyy');
    return formatter.format(dateTime);
  }

  Future<void> fetchUserName() async {
    try {
      final profile = await _userRepo.getUserProfile();
      emit(
        state.copyWith(userName: profile.name, userEmail: profile.email),
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final incomeTemp = await _transactionRepo.getTransactions(
        monthYear: state.formattedDate,
        isIncome: true,
      );
      final expenseTemp = await _transactionRepo.getTransactions(
        monthYear: state.formattedDate,
        isIncome: false,
      );
      final allTemp = await _transactionRepo.getTransactions(
        monthYear: state.formattedDate,
      );

      final totalIncome = incomeTemp
          .map<double>((item) => (item.money))
          .fold<double>(0, (prev, amount) => prev + amount);

      final totalExpense = expenseTemp
          .map<double>((item) => (item.money))
          .fold<double>(0, (prev, amount) => prev + amount);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          incomeTransactions: incomeTemp,
          expenseTransactions: expenseTemp,
          allTransactions: allTemp,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          totalSaving: double.parse(
            (totalIncome - totalExpense).toStringAsFixed(2),
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void changeMonth(int newMonth) {
    final formattedDate = getMonthYearString(newMonth, state.year);
    emit(state.copyWith(month: newMonth, formattedDate: formattedDate));
    fetchData();
  }

  void changeYear(int newYear) {
    final formattedDate = getMonthYearString(state.month, newYear);
    emit(state.copyWith(year: newYear, formattedDate: formattedDate));
    fetchData();
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionRepo.deleteTransaction(id);
      fetchData();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
