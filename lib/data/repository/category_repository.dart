import 'package:dio/dio.dart';
import 'package:money_mate/data/network/dio_client.dart';

abstract class CategoryRepository {
  Future<List<Map<String, dynamic>>> getCategories({bool? isIncome});
  Future<void> addCategory(String icon, String name, bool isIncome,
      [double? limit]);
  Future<void> updateCategory(
      String id, String icon, String name, bool isIncome, double limit);
  Future<void> deleteCategory(String id);
  Future<void> deleteAllCategories(bool isIncome);
  Future<Map<String, dynamic>> getCategory(String id);
  Future<void> updateLimit(String catId, double limit);
  Future<void> restoreLimit(String catId);
  Future<void> restoreAllLimit();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Map<String, dynamic>>> getCategories({bool? isIncome}) async {
    try {
      final response = await _dio.get(
        '/categories',
        queryParameters: isIncome != null ? {'isIncome': isIncome} : null,
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addCategory(String icon, String name, bool isIncome,
      [double? limit]) async {
    try {
      await _dio.post('/categories', data: {
        'icon': icon,
        'name': name,
        'isIncome': isIncome,
        'limit': limit ?? 0,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(
      String id, String icon, String name, bool isIncome, double limit) async {
    try {
      await _dio.put('/categories/$id', data: {
        'icon': icon,
        'name': name,
        'isIncome': isIncome,
        'limit': limit,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _dio.delete('/categories/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllCategories(bool isIncome) async {
    try {
      await _dio.delete('/categories', queryParameters: {'isIncome': isIncome});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getCategory(String id) async {
    try {
      final response = await _dio.get('/categories/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateLimit(String catId, double limit) async {
    try {
      await _dio.patch('/categories/$catId/limit', data: {'limit': limit});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> restoreLimit(String catId) async {
    try {
      await _dio.patch('/categories/$catId/limit', data: {'limit': 0});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> restoreAllLimit() async {
    try {
      await _dio.post('/categories/restore-all-limits');
    } catch (e) {
      rethrow;
    }
  }
}
