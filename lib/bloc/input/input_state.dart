import 'package:equatable/equatable.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

enum InputStatus { initial, loading, success, failure, overLimit }

class InputState extends Equatable {
  final InputStatus status;
  final List<CategoryResponseDto> incomeCategories;
  final List<CategoryResponseDto> expenseCategories;
  final int? selectedIndex;
  final String? catId;
  final String? errorMessage;
  final String? overLimitMessage;

  const InputState({
    this.status = InputStatus.initial,
    this.incomeCategories = const [],
    this.expenseCategories = const [],
    this.selectedIndex,
    this.catId,
    this.errorMessage,
    this.overLimitMessage,
  });

  InputState copyWith({
    InputStatus? status,
    List<CategoryResponseDto>? incomeCategories,
    List<CategoryResponseDto>? expenseCategories,
    int? selectedIndex,
    String? catId,
    String? errorMessage,
    String? overLimitMessage,
  }) {
    return InputState(
      status: status ?? this.status,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      catId: catId ?? this.catId,
      errorMessage: errorMessage ?? this.errorMessage,
      overLimitMessage: overLimitMessage ?? this.overLimitMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incomeCategories,
        expenseCategories,
        selectedIndex,
        catId,
        errorMessage,
        overLimitMessage,
      ];
}
