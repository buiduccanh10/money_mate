import 'package:dio/dio.dart';
import 'package:money_mate/data/network/dio_client.dart';

abstract class TransactionRepository {
  Future<List<Map<String, dynamic>>> getTransactions({
    String? monthYear, // Format "MMMM yyyy"
    String? year,
    bool? isIncome,
    String? catId,
  });

  Future<void> addTransaction(
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  );

  Future<void> updateTransaction(
    String id,
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  );

  Future<void> deleteTransaction(String id);

  Future<void> deleteAllTransactions();

  Future<List<Map<String, dynamic>>> searchTransactions(String query);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Map<String, dynamic>>> getTransactions({
    String? monthYear,
    String? year,
    bool? isIncome,
    String? catId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (monthYear != null) queryParams['monthYear'] = monthYear;
      if (year != null) queryParams['year'] = year;
      if (isIncome != null) queryParams['isIncome'] = isIncome;
      if (catId != null) queryParams['catId'] = catId;

      final response =
          await _dio.get('/transactions', queryParameters: queryParams);
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTransaction(
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  ) async {
    try {
      await _dio.post('/transactions', data: {
        'date': date,
        'description': description,
        'money': money,
        'catId': catId,
        'isIncome': isIncome,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTransaction(
    String id,
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  ) async {
    try {
      await _dio.put('/transactions/$id', data: {
        'date': date,
        'description': description,
        'money': money,
        'catId': catId,
        'isIncome': isIncome,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _dio.delete('/transactions/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllTransactions() async {
    try {
      await _dio.delete('/transactions');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchTransactions(String query) async {
    try {
      final response =
          await _dio.get('/transactions/search', queryParameters: {'q': query});
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
