import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/repositories/movie_repository.dart';

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepository(),
);

class MovieNotifier extends StateNotifier<List<MovieModel>> {
  final Future<List<MovieModel>> Function(String, int) fetcher;
  final String mediaType;
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  MovieNotifier({required this.fetcher, required this.mediaType}) : super([]) {
    loadMore();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    try {
      final items = await fetcher(mediaType, _page);
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
}

final nowPlayingMoviesProvider =
    StateNotifierProvider.autoDispose<MovieNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return MovieNotifier(fetcher: repo.getNowPlaying, mediaType: 'movie');
    });

final topRatedMoviesProvider =
    StateNotifierProvider.autoDispose<MovieNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return MovieNotifier(fetcher: repo.getTopRated, mediaType: 'movie');
    });

final popularMoviesProvider =
    StateNotifierProvider.autoDispose<MovieNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return MovieNotifier(fetcher: repo.getPopular, mediaType: 'movie');
    });

final onAirTvProvider =
    StateNotifierProvider.autoDispose<MovieNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return MovieNotifier(fetcher: repo.getNowPlaying, mediaType: 'tv');
    });

final topRatedTvProvider =
    StateNotifierProvider.autoDispose<MovieNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return MovieNotifier(fetcher: repo.getTopRated, mediaType: 'tv');
    });

final popularTvProvider =
    StateNotifierProvider.autoDispose<MovieNotifier, List<MovieModel>>((ref) {
      final repo = ref.read(movieRepositoryProvider);
      return MovieNotifier(fetcher: repo.getPopular, mediaType: 'tv');
    });

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
