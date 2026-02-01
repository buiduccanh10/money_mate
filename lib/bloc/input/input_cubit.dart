import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/bloc/search/search_cubit.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/bloc/home/home_cubit.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
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
    final DateFormat formatter = DateFormat('MM/yyyy');
    return formatter.format(dateTime);
  }

  Future<void> addTransaction({
    required DateTime date,
    required TimeOfDay time,
    required String description,
    required double money,
    required String catId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      final locale = Localizations.localeOf(context).toString();
      double moneyFinal = money;

      // Limit Check
      final category = await _categoryRepo.getCategory(catId);
      double? limit = category.limit;

      if (limit != null && limit > 0 && !category.isIncome) {
        double totalSpent = await _calculateTotalSpent(category, date);

        if (totalSpent + moneyFinal > limit) {
          var formatter = NumberFormat.simpleCurrency(locale: locale);
          String limitStr = formatter.format((totalSpent + moneyFinal) - limit);

          String periodLabel = '';
          switch (category.limitType) {
            case CategoryResponseDtoLimitType.daily:
              periodLabel = AppLocalizations.of(context)!.daily;
              break;
            case CategoryResponseDtoLimitType.weekly:
              periodLabel = AppLocalizations.of(context)!.weekly;
              break;
            case CategoryResponseDtoLimitType.monthly:
              periodLabel = AppLocalizations.of(context)!.monthly;
              break;
            case CategoryResponseDtoLimitType.yearly:
              periodLabel = AppLocalizations.of(context)!.yearly;
              break;
            default:
              periodLabel = AppLocalizations.of(context)!.monthly;
          }

          emit(
            state.copyWith(
              status: InputStatus.overLimit,
              overLimitMessage:
                  "${AppLocalizations.of(context)!.overLimit} ${category.name} ($periodLabel): $limitStr",
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
      if (context.mounted) {
        context.read<HomeCubit>().fetchData();
        context.read<SearchCubit>().refresh();
        try {
          final chartCubit = context.read<ChartCubit>();
          chartCubit.fetchData();
          chartCubit.refreshDetail();
        } catch (_) {}
      }
    } catch (e) {
      emit(
        state.copyWith(status: InputStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateTransaction({
    required String id,
    required DateTime date,
    required TimeOfDay time,
    required bool isIncome,
    required String description,
    required double money,
    required String catId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      final locale = Localizations.localeOf(context).toString();
      double moneyFinal = money;

      // Limit Check
      final category = await _categoryRepo.getCategory(catId);
      double? limit = category.limit;

      if (limit != null && limit > 0 && !isIncome) {
        double totalSpent = await _calculateTotalSpent(
          category,
          date,
          excludeId: id,
        );

        if (totalSpent + moneyFinal > limit) {
          var formatter = NumberFormat.simpleCurrency(locale: locale);
          String limitStr = formatter.format((totalSpent + moneyFinal) - limit);

          String periodLabel = '';
          switch (category.limitType) {
            case CategoryResponseDtoLimitType.daily:
              periodLabel = AppLocalizations.of(context)!.daily;
              break;
            case CategoryResponseDtoLimitType.weekly:
              periodLabel = AppLocalizations.of(context)!.weekly;
              break;
            case CategoryResponseDtoLimitType.monthly:
              periodLabel = AppLocalizations.of(context)!.monthly;
              break;
            case CategoryResponseDtoLimitType.yearly:
              periodLabel = AppLocalizations.of(context)!.yearly;
              break;
            default:
              periodLabel = AppLocalizations.of(context)!.monthly;
          }

          emit(
            state.copyWith(
              status: InputStatus.overLimit,
              overLimitMessage:
                  "${AppLocalizations.of(context)!.overLimit} ${category.name} ($periodLabel): $limitStr",
            ),
          );
          return;
        }
      }

      String finalDate = DateFormat('yyyy-MM-dd').format(date);
      String finalTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      await _transactionRepo.updateTransaction(
        id,
        finalDate,
        finalTime,
        description,
        moneyFinal,
        catId,
        isIncome,
      );

      emit(state.copyWith(status: InputStatus.success));

      if (context.mounted) {
        context.read<HomeCubit>().fetchData();
        context.read<SearchCubit>().refresh();
        try {
          final chartCubit = context.read<ChartCubit>();
          chartCubit.fetchData();
          chartCubit.refreshDetail();
        } catch (_) {}
      }
    } catch (e) {
      emit(
        state.copyWith(status: InputStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteTransaction(String id, BuildContext context) async {
    emit(state.copyWith(status: InputStatus.loading));
    try {
      await _transactionRepo.deleteTransaction(id);
      emit(state.copyWith(status: InputStatus.success));

      if (context.mounted) {
        context.read<HomeCubit>().fetchData();
        context.read<SearchCubit>().refresh();
        try {
          final chartCubit = context.read<ChartCubit>();
          chartCubit.fetchData();
          chartCubit.refreshDetail();
        } catch (_) {}
      }
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

  Future<double> _calculateTotalSpent(
    CategoryResponseDto category,
    DateTime targetDate, {
    String? excludeId,
  }) async {
    final limitType =
        category.limitType ?? CategoryResponseDtoLimitType.monthly;

    List<TransactionResponseDto> transactions;

    switch (limitType) {
      case CategoryResponseDtoLimitType.daily:
        final monthYear = getMonthYearString(targetDate.month, targetDate.year);
        transactions = await _transactionRepo.getTransactions(
          monthYear: monthYear,
          catId: category.id,
          isIncome: false,
        );
        final targetDateStr = DateFormat('yyyy-MM-dd').format(targetDate);
        transactions = transactions
            .where((t) => t.date == targetDateStr)
            .toList();
        break;
      case CategoryResponseDtoLimitType.weekly:
        final monthYear = getMonthYearString(targetDate.month, targetDate.year);
        transactions = await _transactionRepo.getTransactions(
          monthYear: monthYear,
          catId: category.id,
          isIncome: false,
        );

        final startOfWeek = targetDate.subtract(
          Duration(days: targetDate.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        if (startOfWeek.month != targetDate.month) {
          final prevMonth = getMonthYearString(
            startOfWeek.month,
            startOfWeek.year,
          );
          transactions.addAll(
            await _transactionRepo.getTransactions(
              monthYear: prevMonth,
              catId: category.id,
              isIncome: false,
            ),
          );
        } else if (endOfWeek.month != targetDate.month) {
          final nextMonth = getMonthYearString(endOfWeek.month, endOfWeek.year);
          transactions.addAll(
            await _transactionRepo.getTransactions(
              monthYear: nextMonth,
              catId: category.id,
              isIncome: false,
            ),
          );
        }

        transactions = transactions.where((t) {
          final tDate = DateFormat('yyyy-MM-dd').parse(t.date);
          return tDate.isAfter(
                startOfWeek.subtract(const Duration(seconds: 1)),
              ) &&
              tDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
        break;
      case CategoryResponseDtoLimitType.monthly:
        final monthYear = getMonthYearString(targetDate.month, targetDate.year);
        transactions = await _transactionRepo.getTransactions(
          monthYear: monthYear,
          catId: category.id,
          isIncome: false,
        );
        break;
      case CategoryResponseDtoLimitType.yearly:
        transactions = await _transactionRepo.getTransactions(
          year: targetDate.year.toString(),
          catId: category.id,
          isIncome: false,
        );
        break;
      default:
        final monthYear = getMonthYearString(targetDate.month, targetDate.year);
        transactions = await _transactionRepo.getTransactions(
          monthYear: monthYear,
          catId: category.id,
          isIncome: false,
        );
    }

    if (excludeId != null) {
      transactions = transactions.where((t) => t.id != excludeId).toList();
    }

    return transactions.fold<double>(0, (sum, item) => sum + item.money);
  }
}
