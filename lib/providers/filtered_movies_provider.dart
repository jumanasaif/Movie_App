import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/repositories/movie_repository.dart';
import 'package:movie_app/providers/movie_providers.dart';
import 'package:movie_app/providers/search_filter_provider.dart';

class FilteredMoviesNotifier extends StateNotifier<List<MovieModel>> {
  final MovieRepository repo;
  final String category;
  String mediaType;
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  FilteredMoviesNotifier({
    required this.repo,
    required this.category,
    required this.mediaType,
  }) : super([]) {
    loadMore();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    try {
      final items = await repo.discover(
        mediaType: mediaType,
        page: _page,
        category: category,
      );
      if (items.isEmpty)
        _hasMore = false;
      else {
        state = [...state, ...items];
        _page++;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = [];
    await loadMore();
  }

  Future<void> applyFilters({
    String? query,
    String? sortBy,
    String? withGenres,
    String? year,
  }) async {
    _page = 1;
    _hasMore = true;
    state = [];
    try {
      final items = await repo.discover(
        mediaType: mediaType,
        page: _page,
        category: category,
        query: query,
        sortBy: sortBy,
        withGenres: withGenres,
        year: year,
      );
      state = items;
      _page++;
    } catch (e) {}
  }

  void setMediaType(String t) {
    if (t == mediaType) return;
    mediaType = t;
    refresh();
  }
}

final filteredPlayingNowMoviesProvider =
    StateNotifierProvider<FilteredMoviesNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      final mediaType = ref.read(searchFilterProvider).mediaType;
      return FilteredMoviesNotifier(
        repo: repo,
        category: 'playing_now',
        mediaType: mediaType,
      );
    });

final filteredTopRatedMoviesProvider =
    StateNotifierProvider<FilteredMoviesNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      final mediaType = ref.read(searchFilterProvider).mediaType;
      return FilteredMoviesNotifier(
        repo: repo,
        category: 'top_rated',
        mediaType: mediaType,
      );
    });

final filteredPopularMoviesProvider =
    StateNotifierProvider<FilteredMoviesNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      final mediaType = ref.read(searchFilterProvider).mediaType;
      return FilteredMoviesNotifier(
        repo: repo,
        category: 'popular',
        mediaType: mediaType,
      );
    });

final filteredPlayingNowTvProvider =
    StateNotifierProvider.autoDispose<FilteredMoviesNotifier, List<MovieModel>>(
      (ref) {
        final repo = ref.read(movieRepositoryProvider);
        final searchState = ref.watch(searchFilterProvider);
        return FilteredMoviesNotifier(
          repo: repo,
          category: 'playing_now',
          mediaType: 'tv',
        )..applyFilters(
          query: searchState.query,
          sortBy: searchState.sortBy,
          withGenres: searchState.withGenres,
          year: searchState.year,
        );
      },
    );

final filteredTopRatedTvProvider =
    StateNotifierProvider.autoDispose<FilteredMoviesNotifier, List<MovieModel>>(
      (ref) {
        final repo = ref.read(movieRepositoryProvider);
        final searchState = ref.watch(searchFilterProvider);
        return FilteredMoviesNotifier(
          repo: repo,
          category: 'top_rated',
          mediaType: 'tv',
        )..applyFilters(
          query: searchState.query,
          sortBy: searchState.sortBy,
          withGenres: searchState.withGenres,
          year: searchState.year,
        );
      },
    );

final filteredPopularTvProvider =
    StateNotifierProvider.autoDispose<FilteredMoviesNotifier, List<MovieModel>>(
      (ref) {
        final repo = ref.read(movieRepositoryProvider);
        final searchState = ref.watch(searchFilterProvider);
        return FilteredMoviesNotifier(
          repo: repo,
          category: 'popular',
          mediaType: 'tv',
        )..applyFilters(
          query: searchState.query,
          sortBy: searchState.sortBy,
          withGenres: searchState.withGenres,
          year: searchState.year,
        );
      },
    );

final filteredAllMoviesProvider =
    StateNotifierProvider<FilteredMoviesNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return FilteredMoviesNotifier(
        repo: repo,
        category: 'all',
        mediaType: 'movie',
      );
    });

final filteredAllTvProvider =
    StateNotifierProvider<FilteredMoviesNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return FilteredMoviesNotifier(
        repo: repo,
        category: 'all',
        mediaType: 'tv',
      );
    });
