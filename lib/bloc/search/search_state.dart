import 'package:equatable/equatable.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<TransactionResponseDto> searchResults;
  final String? errorMessage;
  final String query;
  final String? catId;

  const SearchState({
    this.status = SearchStatus.initial,
    this.searchResults = const [],
    this.errorMessage,
    this.query = '',
    this.catId,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<TransactionResponseDto>? searchResults,
    String? errorMessage,
    String? query,
    String? catId,
    bool clearCatId = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      catId: clearCatId ? null : (catId ?? this.catId),
    );
  }

  @override
  List<Object?> get props => [
    status,
    searchResults,
    errorMessage,
    query,
    catId,
  ];
}
