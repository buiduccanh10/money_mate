import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepo;

  CategoryCubit({required CategoryRepository categoryRepo})
      : _categoryRepo = categoryRepo,
        super(const CategoryState()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      final incomeTemp = await _categoryRepo.getCategories(isIncome: true);
      final expenseTemp = await _categoryRepo.getCategories(isIncome: false);
      emit(state.copyWith(
        status: CategoryStatus.success,
        incomeCategories: incomeTemp,
        expenseCategories: expenseTemp,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: CategoryStatus.failure, errorMessage: e.toString()));
    }
  }

  void selectCategory(int index, bool isIncome) {
    final list = isIncome ? state.incomeCategories : state.expenseCategories;
    if (index >= 0 && index < list.length) {
      emit(state.copyWith(
        selectedIndex: index,
        selectedIcon: list[index]['icon'],
        selectedName: list[index]['name'],
        isIncome: list[index]['isIncome'],
      ));
    }
  }

  Future<void> addCategory(
      String icon, String name, bool isIncome, double limit) async {
    try {
      await _categoryRepo.addCategory(icon, name, isIncome, limit);
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateCategory(
      String id, String icon, String name, bool isIncome, double limit) async {
    try {
      await _categoryRepo.updateCategory(id, icon, name, isIncome, limit);
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

  Future<void> updateLimit(String catId, double limit) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _categoryRepo.updateLimit(catId, limit);
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(
          status: CategoryStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> restoreLimit(String catId) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _categoryRepo.restoreLimit(catId);
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(
          status: CategoryStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> restoreAllLimits() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _categoryRepo.restoreAllLimit();
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (e) {
      emit(state.copyWith(
          status: CategoryStatus.failure, errorMessage: e.toString()));
    }
  }
}
