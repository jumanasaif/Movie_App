import 'package:flutter/material.dart';
import 'package:movie_app/data/models/media_details_model.dart';

class DetailOverview extends StatelessWidget {
  final MovieDetails details;

  const DetailOverview({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    if (details.overview.isEmpty ||
        details.overview == 'No description available') {
      return const SizedBox();
    }

    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getTitleSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isLargeScreen ? 12 : 8),
        Text(
          details.overview,
          style: TextStyle(
            color: Colors.white70,
            fontSize: _getContentSize(context),
            height: 1.5,
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

  double _getContentSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 18;
    if (width > 800) return 17;
    if (width > 600) return 16;
    return 16;
  }
}
