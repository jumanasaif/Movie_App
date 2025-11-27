import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/cast_member.dart';
import 'package:movie_app/data/models/media_details_model.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/video.dart';
import 'package:movie_app/providers/movie_providers.dart';

final mediaDetailsProvider =
    FutureProvider.family<MovieDetails, ({int id, String mediaType})>((
      ref,
      params,
    ) async {
      final repo = ref.read(movieRepositoryProvider);
      return await repo.getMovieDetails(params.id, params.mediaType);
    });

final similarMediaProvider =
    FutureProvider.family<List<MovieModel>, ({int id, String mediaType})>((
      ref,
      params,
    ) async {
      final repo = ref.read(movieRepositoryProvider);
      return await repo.getSimilar(params.id, params.mediaType);
    });

final creditsProvider =
    FutureProvider.family<List<CastMember>, ({int id, String mediaType})>((
      ref,
      params,
    ) async {
      final repo = ref.read(movieRepositoryProvider);
      return await repo.getCredits(params.id, params.mediaType);
    });

final videosProvider =
    FutureProvider.family<List<Video>, ({int id, String mediaType})>((
      ref,
      params,
    ) async {
      final repo = ref.read(movieRepositoryProvider);
      return await repo.getVideos(params.id, params.mediaType);
    });
