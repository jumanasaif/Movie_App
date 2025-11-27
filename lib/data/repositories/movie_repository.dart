import 'package:movie_app/data/models/cast_member.dart';
import 'package:movie_app/data/models/media_details_model.dart';
import 'package:movie_app/data/models/video.dart';

import '../services/api_service.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final ApiService _api = ApiService();

  Future<List<MovieModel>> getNowPlaying(String type, int page) async {
    String endpoint;

    if (type == 'movie') {
      endpoint = '/movie/now_playing';
    } else {
      endpoint = '/tv/on_the_air';
    }

    return _api.fetchMovies(mediaType: type, category: endpoint, page: page);
  }

  Future<List<MovieModel>> getTopRated(String type, int page) async {
    return _api.fetchMovies(
      mediaType: type,
      category: '/$type/top_rated',
      page: page,
    );
  }

  Future<List<MovieModel>> getPopular(String type, int page) async {
    return _api.fetchMovies(
      mediaType: type,
      category: '/$type/popular',
      page: page,
    );
  }

  Future<Map<int, String>> getGenres(String mediaType) async {
    return _api.fetchGenres(mediaType);
  }

  Future<List<MovieModel>> discover({
    required String mediaType,
    required int page,
    required String category,
    String? query,
    String? sortBy,
    String? withGenres,
    String? year,
  }) async {
    String endpoint;
    switch (category) {
      case 'playing_now':
        endpoint = mediaType == 'movie'
            ? '/movie/now_playing'
            : '/tv/on_the_air';
        break;

      case 'top_rated':
        endpoint = '/$mediaType/top_rated';
        break;
      case 'popular':
        endpoint = '/$mediaType/popular';
        break;
      case 'all':
      default:
        endpoint = '/$mediaType/popular';
    }
    return _api.fetchMovies(
      mediaType: mediaType,
      category: endpoint,
      page: page,
      query: query,
      sortBy: sortBy,
      withGenres: withGenres,
      year: year,
    );
  }

  Future<MovieDetails> getMovieDetails(int id, String mediaType) async {
    return await _api.fetchMovieDetails(id, mediaType);
  }

  Future<List<MovieModel>> getSimilar(
    int id,
    String mediaType, {
    int page = 1,
  }) async {
    return await _api.fetchSimilar(id, mediaType, page: page);
  }

  Future<List<CastMember>> getCredits(int id, String mediaType) async {
    return await _api.fetchCredits(id, mediaType);
  }

  Future<List<Video>> getVideos(int id, String mediaType) async {
    return await _api.fetchVideos(id, mediaType);
  }
}
