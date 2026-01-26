import 'package:equatable/equatable.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<Map<String, dynamic>> incomeCategories;
  final List<Map<String, dynamic>> expenseCategories;
  final String? errorMessage;
  final int? selectedIndex;
  final String? selectedIcon;
  final String? selectedName;
  final bool? isIncome;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.incomeCategories = const [],
    this.expenseCategories = const [],
    this.errorMessage,
    this.selectedIndex,
    this.selectedIcon,
    this.selectedName,
    this.isIncome,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<Map<String, dynamic>>? incomeCategories,
    List<Map<String, dynamic>>? expenseCategories,
    String? errorMessage,
    int? selectedIndex,
    String? selectedIcon,
    String? selectedName,
    bool? isIncome,
  }) {
    return CategoryState(
      status: status ?? this.status,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedName: selectedName ?? this.selectedName,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incomeCategories,
        expenseCategories,
        errorMessage,
        selectedIndex,
        selectedIcon,
        selectedName,
        isIncome,
      ];
}
