import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

abstract class CategoryRepository {
  Future<List<CategoryResponseDto>> getCategories({bool? isIncome});
  Future<CategoryResponseDto> addCategory(
    String icon,
    String name,
    bool isIncome, [
    double? limit,
    CreateCategoryDtoLimitType? limitType,
  ]);
  Future<CategoryResponseDto> updateCategory(
    String id,
    String icon,
    String name,
    bool isIncome,
    double limit,
    UpdateCategoryDtoLimitType? limitType,
  );
  Future<void> deleteCategory(String id);
  Future<void> deleteAllCategories(bool isIncome);
  Future<CategoryResponseDto> getCategory(String id);
  Future<void> updateLimit(
    String catId,
    double limit,
    UpdateLimitDtoLimitType? limitType,
  );
  Future<void> restoreLimit(String catId);
  Future<void> restoreAllLimit();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final _api = ApiClient.api;

  @override
  Future<List<CategoryResponseDto>> getCategories({bool? isIncome}) async {
    final response = await _api.apiCategoriesGet(
      isIncome: isIncome?.toString(),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to fetch categories');
    }
  }

  @override
  Future<CategoryResponseDto> addCategory(
    String icon,
    String name,
    bool isIncome, [
    double? limit,
    CreateCategoryDtoLimitType? limitType,
  ]) async {
    final response = await _api.apiCategoriesPost(
      body: CreateCategoryDto(
        icon: icon,
        name: name,
        isIncome: isIncome,
        limit: limit,
        limitType: limitType,
      ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to create category');
    }
  }

  @override
  Future<CategoryResponseDto> updateCategory(
    String id,
    String icon,
    String name,
    bool isIncome,
    double limit,
    UpdateCategoryDtoLimitType? limitType,
  ) async {
    final response = await _api.apiCategoriesIdPut(
      id: id,
      body: UpdateCategoryDto(
        icon: icon,
        name: name,
        isIncome: isIncome,
        limit: limit,
        limitType: limitType,
      ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to update category');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    final response = await _api.apiCategoriesIdDelete(id: id);
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete category');
    }
  }

  @override
  Future<void> deleteAllCategories(bool isIncome) async {
    final response = await _api.apiCategoriesDelete(
      isIncome: isIncome.toString(),
    );
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete all categories');
    }
  }

  @override
  Future<CategoryResponseDto> getCategory(String id) async {
    final response = await _api.apiCategoriesIdGet(id: id);
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to fetch category');
    }
  }

  @override
  Future<void> updateLimit(
    String catId,
    double limit,
    UpdateLimitDtoLimitType? limitType,
  ) async {
    final response = await _api.apiCategoriesIdLimitPatch(
      id: catId,
      body: UpdateLimitDto(limit: limit, limitType: limitType),
    );
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to update limit');
    }
  }

  @override
  Future<void> restoreLimit(String catId) async {
    await updateLimit(catId, 0, UpdateLimitDtoLimitType.monthly);
  }

  @override
  Future<void> restoreAllLimit() async {
    final response = await _api.apiCategoriesRestoreAllLimitsPost();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to restore all limits');
    }
  }
}
