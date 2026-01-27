import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

abstract class TransactionRepository {
  Future<List<TransactionResponseDto>> getTransactions({
    String? monthYear,
    String? year,
    bool? isIncome,
    String? catId,
  });

  Future<TransactionResponseDto> addTransaction(
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  );

  Future<TransactionResponseDto> updateTransaction(
    String id,
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  );

  Future<void> deleteTransaction(String id);

  Future<void> deleteAllTransactions();

  Future<List<TransactionResponseDto>> searchTransactions(String query);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final _api = ApiClient.api;

  @override
  Future<List<TransactionResponseDto>> getTransactions({
    String? monthYear,
    String? year,
    bool? isIncome,
    String? catId,
  }) async {
    final response = await _api.apiTransactionsGet(
      monthYear: monthYear,
      year: year,
      isIncome: isIncome?.toString(),
      catId: catId,
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to fetch transactions');
    }
  }

  @override
  Future<TransactionResponseDto> addTransaction(
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  ) async {
    final response = await _api.apiTransactionsPost(
      body: CreateTransactionDto(
        date: date,
        description: description,
        money: money,
        catId: catId,
        isIncome: isIncome,
      ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to create transaction');
    }
  }

  @override
  Future<TransactionResponseDto> updateTransaction(
    String id,
    String date,
    String description,
    double money,
    String catId,
    bool isIncome,
  ) async {
    final response = await _api.apiTransactionsIdPut(
      id: id,
      body: UpdateTransactionDto(
        date: date,
        description: description,
        money: money,
        catId: catId,
        isIncome: isIncome,
      ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to update transaction');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final response = await _api.apiTransactionsIdDelete(id: id);
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete transaction');
    }
  }

  @override
  Future<void> deleteAllTransactions() async {
    final response = await _api.apiTransactionsDelete();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Failed to delete all transactions');
    }
  }

  @override
  Future<List<TransactionResponseDto>> searchTransactions(String query) async {
    final response = await _api.apiTransactionsSearchGet(q: query);
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception(response.error ?? 'Failed to search transactions');
    }
  }
}
