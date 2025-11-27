import 'package:flutter/material.dart';
import 'package:movie_app/data/models/media_details_model.dart';

class DetailHeader extends StatelessWidget {
  final MovieDetails details;
  final String posterUrl;
  final double? currentUserRating;

  const DetailHeader({
    super.key,
    required this.details,
    required this.posterUrl,
    required this.currentUserRating,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster Image
        Container(
          width: _getPosterWidth(context),
          height: _getPosterHeight(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(posterUrl, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: isLargeScreen ? 24 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getTitleSize(context),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isLargeScreen ? 12 : 8),

              // User Rating
              if (currentUserRating != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 16 : 12,
                    vertical: isLargeScreen ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: _getIconSize(context),
                      ),
                      SizedBox(width: isLargeScreen ? 8 : 4),
                      Text(
                        'Your rating: ${currentUserRating!.toStringAsFixed(1)}/10',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: _getFontSize(context, 12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? 12 : 8),
              ],

              // Rating and Info Row
              _buildRatingInfoRow(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingInfoRow(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: _getRatingSize(context),
              height: _getRatingSize(context),
              child: CircularProgressIndicator(
                value: details.voteAverage / 10,
                backgroundColor: Colors.grey.shade800,
                color: _getRatingColor(details.voteAverage),
                strokeWidth: 4,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(details.voteAverage * 10).toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _getFontSize(context, 12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${details.voteCount}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: _getFontSize(context, 8),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: isLargeScreen ? 16 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, Icons.calendar_today, details.releaseDate),
              SizedBox(height: isLargeScreen ? 8 : 4),
              if (details.runtime != null)
                _buildInfoRow(
                  context,
                  Icons.access_time,
                  '${details.runtime} min',
                ),
              SizedBox(height: isLargeScreen ? 8 : 4),
              _buildInfoRow(
                context,
                Icons.movie,
                details.mediaType.toUpperCase(),
              ),
              SizedBox(height: isLargeScreen ? 8 : 4),
              _buildInfoRow(
                context,
                Icons.star,
                'Popularity: ${details.popularity.toStringAsFixed(1)}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: _getIconSize(context)),
        SizedBox(width: _getSpacing(context)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: _getFontSize(context, 14),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  double _getPosterWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 180;
    if (width > 800) return 150;
    if (width > 600) return 140;
    return 120;
  }

  double _getPosterHeight(BuildContext context) {
    return _getPosterWidth(context) * 1.5;
  }

  double _getTitleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 28;
    if (width > 800) return 24;
    if (width > 600) return 22;
    return 20;
  }

  double _getRatingSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 60;
    return 50;
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 20;
    return 16;
  }

  double _getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 12;
    return 8;
  }

  double _getFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return baseSize * 1.3;
    if (width > 800) return baseSize * 1.15;
    return baseSize;
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7) return Colors.green;
    if (rating >= 5) return Colors.orange;
    return Colors.red;
  }
}
