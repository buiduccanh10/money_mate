import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepo;
  final TransactionRepository _transactionRepo;

  CategoryCubit({
    required CategoryRepository categoryRepo,
    required TransactionRepository transactionRepo,
  }) : _categoryRepo = categoryRepo,
       _transactionRepo = transactionRepo,
       super(const CategoryState()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      final incomeTemp = await _categoryRepo.getCategories(isIncome: true);
      final expenseTemp = await _categoryRepo.getCategories(isIncome: false);
      emit(
        state.copyWith(
          status: CategoryStatus.success,
          incomeCategories: incomeTemp,
          expenseCategories: expenseTemp,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void selectCategory(int index, bool isIncome) {
    final list = isIncome ? state.incomeCategories : state.expenseCategories;
    if (index >= 0 && index < list.length) {
      emit(
        state.copyWith(
          selectedIndex: index,
          selectedIcon: list[index].icon,
          selectedName: list[index].name,
          isIncome: list[index].isIncome,
        ),
      );
    }
  }

  Future<void> addCategory(
    String icon,
    String name,
    bool isIncome,
    double limit,
    CreateCategoryDtoLimitType? limitType,
  ) async {
    try {
      await _categoryRepo.addCategory(icon, name, isIncome, limit, limitType);
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateCategory(
    String id,
    String icon,
    String name,
    bool isIncome,
    double limit,
    UpdateCategoryDtoLimitType? limitType,
  ) async {
    try {
      await _categoryRepo.updateCategory(
        id,
        icon,
        name,
        isIncome,
        limit,
        limitType,
      );
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _categoryRepo.deleteCategory(id);
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteAllCategories(bool isIncome) async {
    try {
      await _categoryRepo.deleteAllCategories(isIncome);
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateLimit(
    String catId,
    double limit,
    UpdateLimitDtoLimitType? limitType,
    AppLocalizations l10n,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      if (limit > 0) {
        // Map UpdateLimitDtoLimitType to CategoryResponseDtoLimitType for helper
        final checkLimitType = CategoryResponseDtoLimitType.values.firstWhere(
          (e) => e.value == limitType?.value,
          orElse: () => CategoryResponseDtoLimitType.monthly,
        );

        final totalSpent = await _calculateTotalSpent(
          catId,
          checkLimitType,
          DateTime.now(),
        );
        if (totalSpent > limit) {
          throw Exception(
            l10n.limitExceededError(totalSpent.toStringAsFixed(0)),
          );
        }
      }

      await _categoryRepo.updateLimit(catId, limit, limitType);
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  String getMonthYearString(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MM/yyyy');
    return formatter.format(dateTime);
  }

  Future<double> _calculateTotalSpent(
    String catId,
    CategoryResponseDtoLimitType limitType,
    DateTime targetDate,
  ) async {
    List<TransactionResponseDto> transactions;

    switch (limitType) {
      case CategoryResponseDtoLimitType.daily:
        final monthYear = getMonthYearString(targetDate.month, targetDate.year);
        transactions = await _transactionRepo.getTransactions(
          monthYear: monthYear,
          catId: catId,
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
          catId: catId,
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
              catId: catId,
              isIncome: false,
            ),
          );
        } else if (endOfWeek.month != targetDate.month) {
          final nextMonth = getMonthYearString(endOfWeek.month, endOfWeek.year);
          transactions.addAll(
            await _transactionRepo.getTransactions(
              monthYear: nextMonth,
              catId: catId,
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
          catId: catId,
          isIncome: false,
        );
        break;
      case CategoryResponseDtoLimitType.yearly:
        transactions = await _transactionRepo.getTransactions(
          year: targetDate.year.toString(),
          catId: catId,
          isIncome: false,
        );
        break;
      default:
        final monthYear = getMonthYearString(targetDate.month, targetDate.year);
        transactions = await _transactionRepo.getTransactions(
          monthYear: monthYear,
          catId: catId,
          isIncome: false,
        );
    }

    return transactions.fold<double>(0, (sum, item) => sum + item.money);
  }

  Future<void> restoreLimit(String catId) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _categoryRepo.restoreLimit(catId);
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> restoreAllLimits() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _categoryRepo.restoreAllLimit();
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
