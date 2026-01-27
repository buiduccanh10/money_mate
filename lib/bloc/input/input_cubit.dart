import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final CategoryRepository _categoryRepo;
  final TransactionRepository _transactionRepo;

  InputCubit({
    required CategoryRepository categoryRepo,
    required TransactionRepository transactionRepo,
  }) : _categoryRepo = categoryRepo,
       _transactionRepo = transactionRepo,
       super(const InputState()) {
    fetchData();
  }

  Future<void> fetchData() async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      final incomeTemp = await _categoryRepo.getCategories(isIncome: true);
      final expenseTemp = await _categoryRepo.getCategories(isIncome: false);
      emit(
        state.copyWith(
          status: InputStatus.initial,
          incomeCategories: incomeTemp,
          expenseCategories: expenseTemp,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: InputStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void selectCategory(int index, String catId) {
    emit(
      state.copyWith(
        selectedIndex: index,
        catId: catId,
        status: InputStatus.initial,
      ),
    );
  }

  void resetSelection() {
    emit(
      InputState(
        status: state.status,
        incomeCategories: state.incomeCategories,
        expenseCategories: state.expenseCategories,
        selectedIndex: null,
        catId: null,
        errorMessage: state.errorMessage,
        overLimitMessage: state.overLimitMessage,
      ),
    );
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  Future<void> addTransaction({
    required DateTime date,
    required TimeOfDay time,
    required String description,
    required String money,
    required String catId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      final locale = Localizations.localeOf(context).toString();
      String formatMoney = locale == 'vi'
          ? money.replaceAll('.', '')
          : money.replaceAll(',', '.');
      double moneyFinal = double.parse(formatMoney);

      // Limit Check
      final category = await _categoryRepo.getCategory(catId);
      double? limit = category.limit;
      String formatDateString = getMonthYearString(date.month, date.year);

      if (limit != null && limit > 0) {
        final categoryTransactions = await _transactionRepo.getTransactions(
          monthYear: formatDateString,
          isIncome: false,
          catId: catId,
        );

        double totalSpent = categoryTransactions
            .map<double>((item) => (item.money))
            .fold<double>(0, (prev, amount) => prev + amount);

        if (totalSpent + moneyFinal > limit) {
          var formatter = NumberFormat.simpleCurrency(locale: locale);
          String limitStr = formatter.format((totalSpent + moneyFinal) - limit);

          emit(
            state.copyWith(
              status: InputStatus.overLimit,
              overLimitMessage: "${category.name}: $limitStr",
            ),
          );
          return;
        }
      }

      String finalDate = DateFormat('yyyy-MM-dd').format(date);
      String finalTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      bool isIncome = category.isIncome;

      await _transactionRepo.addTransaction(
        finalDate,
        finalTime,
        description,
        moneyFinal,
        catId,
        isIncome,
      );

      emit(state.copyWith(status: InputStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: InputStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateTransaction({
    required String id,
    required String date,
    required bool isIncome,
    required String description,
    required String money,
    required String catId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      final locale = Localizations.localeOf(context).toString();
      String formatMoney = locale == 'vi'
          ? money.replaceAll('.', '')
          : money.replaceAll(',', '.');
      double moneyFinal = double.parse(formatMoney);

      await _transactionRepo.updateTransaction(
        id,
        date,
        description,
        moneyFinal,
        catId,
        isIncome,
      );

      emit(state.copyWith(status: InputStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: InputStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void resetStatus() {
    emit(
      state.copyWith(
        status: InputStatus.initial,
        overLimitMessage: null,
        errorMessage: null,
      ),
    );
  }
}
