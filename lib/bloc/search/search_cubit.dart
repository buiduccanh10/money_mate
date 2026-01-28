import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TransactionRepository _transactionRepo;

  SearchCubit({required TransactionRepository transactionRepo})
    : _transactionRepo = transactionRepo,
      super(const SearchState());

  Future<void> searchTransactions(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(searchResults: [], query: '', clearCatId: true));
      return;
    }

    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        clearCatId: true,
      ),
    );
    try {
      final results = await _transactionRepo.searchTransactions(query);
      emit(
        state.copyWith(status: SearchStatus.success, searchResults: results),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    if (state.catId != null) {
      await searchByCategory(state.catId!);
    } else if (state.query.isNotEmpty) {
      await searchTransactions(state.query);
    }
  }

  Future<void> clearSearch() async {
    emit(
      state.copyWith(
        searchResults: [],
        query: '',
        catId: null,
        clearCatId: true,
      ),
    );
  }

  Future<void> searchByCategory(String catId) async {
    emit(state.copyWith(status: SearchStatus.loading, catId: catId, query: ''));
    try {
      final results = await _transactionRepo.getTransactions(catId: catId);
      emit(
        state.copyWith(status: SearchStatus.success, searchResults: results),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
