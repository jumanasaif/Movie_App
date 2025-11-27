import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/widgets/movie_card.dart';

class DetailSimilar extends ConsumerWidget {
  final AsyncValue<List<MovieModel>> similarAsync;
  final String mediaType;

  const DetailSimilar({
    super.key,
    required this.similarAsync,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return similarAsync.when(
      loading: () => _buildLoading(context),
      error: (error, stack) => const SizedBox(),
      data: (similar) {
        if (similar.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Similar ${mediaType == 'movie' ? 'Movies' : 'TV Shows'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: _getTitleSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _getSpacing(context)),
            SizedBox(
              height: _getSimilarHeight(context),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similar.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: _getSpacing(context)),
                    child: MovieCard(
                      item: similar[index],
                      width: _getCardWidth(context),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar ${mediaType == 'movie' ? 'Movies' : 'TV Shows'}',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getTitleSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _getSpacing(context)),
        SizedBox(
          height: _getSimilarHeight(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: _getCardWidth(context),
                margin: EdgeInsets.only(right: _getSpacing(context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double _getTitleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 24;
    if (width > 800) return 22;
    if (width > 600) return 20;
    return 18;
  }

  double _getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 16;
    return 12;
  }

  double _getSimilarHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 320;
    if (width > 800) return 300;
    return 280;
  }

  double _getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return MediaQuery.of(context).size.width * 0.25;
    if (width > 800) return MediaQuery.of(context).size.width * 0.3;
    if (width > 600) return MediaQuery.of(context).size.width * 0.35;
    return MediaQuery.of(context).size.width * 0.4;
  }
}
