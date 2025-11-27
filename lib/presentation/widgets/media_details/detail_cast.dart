import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/cast_member.dart';

class DetailCast extends ConsumerWidget {
  final AsyncValue<List<CastMember>> creditsAsync;
  final String mediaType;

  const DetailCast({
    super.key,
    required this.creditsAsync,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return creditsAsync.when(
      loading: () => _buildLoading(context),
      error: (error, stack) => const SizedBox(),
      data: (cast) {
        if (cast.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Billed Cast',
              style: TextStyle(
                color: Colors.white,
                fontSize: _getTitleSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _getSpacing(context)),
            SizedBox(
              height: _getCastHeight(context),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                itemBuilder: (context, index) {
                  final person = cast[index];
                  return _buildCastItem(context, person);
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
          'Top Billed Cast',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getTitleSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _getSpacing(context)),
        SizedBox(
          height: _getCastHeight(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: _getCastItemWidth(context),
                margin: EdgeInsets.only(right: _getSpacing(context)),
                child: Column(
                  children: [
                    Container(
                      width: _getCastImageSize(context),
                      height: _getCastImageSize(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[800],
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      ),
                    ),
                    SizedBox(height: _getSpacing(context) / 2),
                    Container(
                      height: _getCastTextSize(context),
                      color: Colors.grey[800],
                    ),
                    SizedBox(height: _getSpacing(context) / 4),
                    Container(
                      height: _getCastTextSize(context) - 2,
                      width: _getCastItemWidth(context) * 0.8,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastItem(BuildContext context, CastMember person) {
    return Container(
      width: _getCastItemWidth(context),
      margin: EdgeInsets.only(right: _getSpacing(context)),
      child: Column(
        children: [
          Container(
            width: _getCastImageSize(context),
            height: _getCastImageSize(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(person.profileUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: _getSpacing(context) / 2),
          Text(
            person.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: _getCastTextSize(context),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: _getSpacing(context) / 4),
          Text(
            person.character,
            style: TextStyle(
              color: Colors.white70,
              fontSize: _getCastSubTextSize(context),
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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

  double _getCastHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 240;
    if (width > 800) return 220;
    return 200;
  }

  double _getCastItemWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 140;
    if (width > 800) return 130;
    if (width > 600) return 120;
    return 110;
  }

  double _getCastImageSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 120;
    if (width > 800) return 110;
    if (width > 600) return 100;
    return 90;
  }

  double _getCastTextSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 14;
    return 12;
  }

  double _getCastSubTextSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 12;
    return 10;
  }
}
