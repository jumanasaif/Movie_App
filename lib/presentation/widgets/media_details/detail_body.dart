import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/media_details_model.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_header.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_overview.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_additional_info.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_videos.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_cast.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_similar.dart';
import 'package:movie_app/providers/media_details_provider.dart';

class DetailBody extends ConsumerWidget {
  final MovieDetails details;
  final MovieModel item;
  final double? currentUserRating;

  const DetailBody({
    super.key,
    required this.details,
    required this.item,
    required this.currentUserRating,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarAsync = ref.watch(
      similarMediaProvider((id: item.id, mediaType: item.mediaType)),
    );
    final creditsAsync = ref.watch(
      creditsProvider((id: item.id, mediaType: item.mediaType)),
    );
    final videosAsync = ref.watch(
      videosProvider((id: item.id, mediaType: item.mediaType)),
    );

    final posterUrl = details.posterPath?.isNotEmpty == true
        ? 'https://image.tmdb.org/t/p/w500${details.posterPath}'
        : 'https://placehold.co/400x600?text=No+Image';

    final backdropUrl = details.backdropPath?.isNotEmpty == true
        ? 'https://image.tmdb.org/t/p/w780${details.backdropPath}'
        : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: _getAppBarHeight(context),
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: backdropUrl != null
                ? Image.network(
                    backdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(posterUrl, fit: BoxFit.cover);
                    },
                  )
                : Image.network(posterUrl, fit: BoxFit.cover),
          ),
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: _getContentPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailHeader(
                  details: details,
                  posterUrl: posterUrl,
                  currentUserRating: currentUserRating,
                ),
                const SizedBox(height: 24),

                if (details.tagline?.isNotEmpty == true) ...[
                  Text(
                    '"${details.tagline!}"',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: _getFontSize(context, 16),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],

                DetailOverview(details: details),
                const SizedBox(height: 24),

                DetailAdditionalInfo(details: details),
                const SizedBox(height: 24),

                DetailVideos(
                  videosAsync: videosAsync,
                  mediaType: item.mediaType,
                ),
                const SizedBox(height: 24),

                DetailCast(
                  creditsAsync: creditsAsync,
                  mediaType: item.mediaType,
                ),
                const SizedBox(height: 24),

                DetailSimilar(
                  similarAsync: similarAsync,
                  mediaType: item.mediaType,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getAppBarHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 500;
    if (width > 800) return 400;
    return 300;
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return const EdgeInsets.all(32);
    if (width > 800) return const EdgeInsets.all(24);
    return const EdgeInsets.all(16);
  }

  double _getFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return baseSize * 1.3;
    if (width > 800) return baseSize * 1.15;
    return baseSize;
  }
}
