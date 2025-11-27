import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/screens/media/media_details_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieModel item;
  final double width;

  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const MovieCard({
    super.key,
    required this.item,
    required this.width,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final posterUrl = item.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${item.posterPath}'
        : 'https://placehold.co/150x220?text=No+Image';

    final rating = ((item.voteAverage ?? 0) * 10).toInt();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                posterUrl,
                fit: BoxFit.cover,
                width: width,
                height: 220,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  height: 220,
                  child: const Icon(Icons.error, color: Colors.white),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade800,
                    height: 220,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    ),
                  );
                },
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),

              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: rating / 100,
                                strokeWidth: 3,
                                color: Colors.amber,
                                backgroundColor: Colors.grey[700],
                              ),
                              Text(
                                '$rating%',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Score',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
