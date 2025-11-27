import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilterState {
  final String query;
  final String mediaType;
  final String? sortBy;
  final String? withGenres;
  final String? year;

  SearchFilterState({
    this.query = '',
    this.mediaType = 'movie',
    this.sortBy,
    this.withGenres,
    this.year,
  });

  SearchFilterState copyWith({
    String? query,
    String? mediaType,
    String? sortBy,
    String? withGenres,
    String? year,
  }) {
    return SearchFilterState(
      query: query ?? this.query,
      mediaType: mediaType ?? this.mediaType,
      sortBy: sortBy ?? this.sortBy,
      withGenres: withGenres ?? this.withGenres,
      year: year ?? this.year,
    );
  }
}

class SearchFilterNotifier extends StateNotifier<SearchFilterState> {
  SearchFilterNotifier() : super(SearchFilterState());

  void setQuery(String q) => state = state.copyWith(query: q);
  void setMediaType(String t) => state = state.copyWith(mediaType: t);
  void setSortBy(String? s) => state = state.copyWith(sortBy: s);
  void setWithGenres(String? g) => state = state.copyWith(withGenres: g);
  void setYear(String? y) => state = state.copyWith(year: y);
}

final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilterState>((ref) {
      return SearchFilterNotifier();
    });
