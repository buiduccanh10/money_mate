import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final CategoryRepository _categoryRepo;
  final TransactionRepository _transactionRepo;
  final FlutterLocalization _localization = FlutterLocalization.instance;

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
    emit(state.copyWith(selectedIndex: index, catId: catId));
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  Future<void> addTransaction({
    required DateTime date,
    required String description,
    required String money,
    required String catId,
    required context,
  }) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      String formatMoney = _localization.currentLocale.toString() == 'vi'
          ? money.replaceAll('.', '')
          : money.replaceAll(',', '.');
      double moneyFinal = double.parse(formatMoney);

      String formatDateString = getMonthYearString(date.month, date.year);

      // Limit Check
      final category = await _categoryRepo.getCategory(catId);
      double? limit = category.limit;

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
          var formatter = NumberFormat.simpleCurrency(
            locale: _localization.currentLocale.toString(),
          );
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

      String finalDate = DateFormat('dd/MM/yyyy').format(date);
      bool isIncome = category.isIncome;

      await _transactionRepo.addTransaction(
        finalDate,
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
  }) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      String formatMoney = _localization.currentLocale.toString() == 'vi'
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
