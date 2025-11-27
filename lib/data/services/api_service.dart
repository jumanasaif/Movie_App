import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/data/models/cast_member.dart';
import 'package:movie_app/data/models/media_details_model.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/video.dart';

class ApiService {
  static const String _apiKey = '4a6b204edac5537cdeaa1868ba388b94';
  static const String _language = 'en-US';
  static const Duration _timeout = Duration(seconds: 10);

  Uri _buildUri(String path, [Map<String, String>? params]) {
    final baseParams = {'api_key': _apiKey, 'language': _language};

    final query = {...baseParams, if (params != null) ...params};

    return Uri.https('api.themoviedb.org', '/3$path', query);
  }

  Future<List<MovieModel>> fetchMovies({
    required String mediaType,
    required String category,
    required int page,
    String? query,
    String? sortBy,
    String? withGenres,
    String? year,
  }) async {
    Uri url;

    if (query != null && query.isNotEmpty) {
      url = _buildUri('/search/$mediaType', {
        'query': query,
        'page': page.toString(),
        'include_adult': 'false',
      });
    } else if (sortBy != null || withGenres != null || year != null) {
      final extras = {
        'page': page.toString(),
        if (sortBy != null) 'sort_by': sortBy,
        if (withGenres != null) 'with_genres': withGenres,
        if (year != null)
          (mediaType == 'movie'
                  ? 'primary_release_year'
                  : 'first_air_date_year'):
              year,
      };
      url = _buildUri('/discover/$mediaType', extras);
    } else {
      url = _buildUri(category, {'page': page.toString()});
    }

    print('fetchMovies URL: $url');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? [];
        return results.map((m) => MovieModel.fromJson(m, mediaType)).toList();
      } else {
        throw Exception(
          'fetchMovies failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print(' fetchMovies error: $e');
      rethrow;
    }
  }

  Future<Map<int, String>> fetchGenres(String mediaType) async {
    final url = _buildUri('/genre/$mediaType/list');
    print(' fetchGenres URL: $url');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List genres = data['genres'] ?? [];
        final Map<int, String> map = {};
        for (final g in genres) {
          map[g['id'] as int] = g['name'] as String;
        }
        return map;
      } else {
        throw Exception('fetchGenres failed: ${response.statusCode}');
      }
    } catch (e) {
      print('fetchGenres error: $e');
      rethrow;
    }
  }

  Future<MovieDetails> fetchMovieDetails(int id, String mediaType) async {
    final url = _buildUri('/$mediaType/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MovieDetails.fromJson(data, mediaType);
    } else {
      throw Exception('Failed to load details: ${response.statusCode}');
    }
  }

  Future<List<MovieModel>> fetchSimilar(
    int id,
    String mediaType, {
    int page = 1,
  }) async {
    final url = _buildUri('/$mediaType/$id/similar', {'page': page.toString()});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((m) => MovieModel.fromJson(m, mediaType)).toList();
    } else {
      throw Exception('Failed to load similar: ${response.statusCode}');
    }
  }

  Future<List<CastMember>> fetchCredits(int id, String mediaType) async {
    final url = _buildUri('/$mediaType/$id/credits');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List cast = data['cast'] ?? [];
      return cast.take(10).map((c) => CastMember.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load credits: ${response.statusCode}');
    }
  }

  Future<List<Video>> fetchVideos(int id, String mediaType) async {
    final url = _buildUri('/$mediaType/$id/videos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List videos = data['results'] ?? [];
      return videos.map((v) => Video.fromJson(v)).toList();
    } else {
      throw Exception('Failed to load videos: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchPersons(
    String path, {
    Map<String, String>? params,
  }) async {
    final url = _buildUri(path, params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }

  static Future<String?> createGuestSession() async {
    try {
      final url = Uri.parse(
        "https://api.themoviedb.org/3/authentication/guest_session/new?api_key=$_apiKey",
      );

      final response = await http.get(url);
      print(
        'Guest Session Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['guest_session_id'];
      } else {
        throw Exception(
          'Failed to create guest session: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error creating guest session: $e');
      return null;
    }
  }

  static Future<bool> addRating({
    required String guestSessionId,
    required int mediaId,
    required String mediaType,
    required double rating,
  }) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/$mediaType/$mediaId/rating?api_key=$_apiKey&guest_session_id=$guestSessionId",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json;charset=utf-8"},
      body: jsonEncode({"value": rating}),
    );

    print('Add Rating Status: ${response.statusCode}');
    print('Add Rating Response: ${response.body}');

    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<bool> deleteRating({
    required String guestSessionId,
    required int mediaId,
    required String mediaType,
  }) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/$mediaType/$mediaId/rating?api_key=$_apiKey&guest_session_id=$guestSessionId",
    );

    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json;charset=utf-8"},
    );

    print('Delete Rating Status: ${response.statusCode}');
    print('Delete Rating Response: ${response.body}');

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getRatedMovies({
    required String guestSessionId,
  }) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/guest_session/$guestSessionId/rated/movies?api_key=$_apiKey",
    );

    final response = await http.get(url);
    print('Rated Movies Response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["results"] ?? [];
    }

    return [];
  }

  static Future<List<dynamic>> getRatedTVShows({
    required String guestSessionId,
  }) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/guest_session/$guestSessionId/rated/tv?api_key=$_apiKey",
    );

    final response = await http.get(url);
    print('Rated TV Response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["results"] ?? [];
    }

    return [];
  }

  static Future<double?> getMediaRating({
    required String guestSessionId,
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final ratedItems = mediaType == 'movie'
          ? await getRatedMovies(guestSessionId: guestSessionId)
          : await getRatedTVShows(guestSessionId: guestSessionId);

      final media = ratedItems.firstWhere(
        (item) => item['id'] == mediaId,
        orElse: () => null,
      );

      return media != null ? (media['rating'] as num).toDouble() : null;
    } catch (e) {
      print('Error getting media rating: $e');
      return null;
    }
  }

  static Future<bool> validateGuestSession(String guestSessionId) async {
    try {
      final url = Uri.parse(
        "https://api.themoviedb.org/3/guest_session/$guestSessionId/rated/movies?api_key=$_apiKey&page=1",
      );

      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
