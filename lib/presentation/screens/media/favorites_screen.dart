import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/services/api_service.dart';
import 'package:movie_app/presentation/screens/media/media_details_screen.dart';
import 'package:movie_app/providers/user_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.transparent,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: userAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.amber)),
        error: (e, s) => Center(
          child: Text(
            "Error loading user data: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please login to view favorites",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text("Login"),
                  ),
                ],
              ),
            );
          }

          final favorites = user.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add movies and TV shows to your favorites",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final mediaId = favorites[index];

              return FutureBuilder<MovieModel?>(
                future: _getMediaDetails(mediaId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildGridLoadingItem();
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return _buildGridErrorItem(mediaId, ref, context);
                  }

                  final media = snapshot.data!;
                  return _buildGridMediaItem(media, ref, context);
                },
              );
            },
          );
        },
      ),
    );
  }

  // 🔧 دالة محسنة لجلب تفاصيل الوسائط (أفلام ومسلسلات)
  Future<MovieModel?> _getMediaDetails(int mediaId) async {
    try {
      final apiService = ApiService();

      try {
        final movieDetails = await apiService.fetchMovieDetails(
          mediaId,
          'movie',
        );
        return MovieModel(
          id: movieDetails.id,
          title: movieDetails.title,
          overview: movieDetails.overview,
          posterPath: movieDetails.posterPath,
          releaseDate: movieDetails.releaseDate,
          voteAverage: movieDetails.voteAverage,
          voteCount: movieDetails.voteCount,
          mediaType: 'movie',
          genreIds: movieDetails.genres.map((g) => g.id).toList(),
        );
      } catch (e) {
        print('Not a movie, trying as TV show: $mediaId');
        final tvDetails = await apiService.fetchMovieDetails(mediaId, 'tv');
        return MovieModel(
          id: tvDetails.id,
          title: tvDetails.title,
          overview: tvDetails.overview,
          posterPath: tvDetails.posterPath,
          releaseDate: tvDetails.releaseDate,
          voteAverage: tvDetails.voteAverage,
          voteCount: tvDetails.voteCount,
          mediaType: 'tv',
          genreIds: tvDetails.genres.map((g) => g.id).toList(),
        );
      }
    } catch (e) {
      print('Error getting media details for $mediaId: $e');
      return null;
    }
  }

  Widget _buildGridMediaItem(
    MovieModel media,
    WidgetRef ref,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(item: media)),
        );
      },
      child: Stack(
        children: [
          Card(
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: media.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w300${media.posterPath}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildGridPlaceholderPoster(
                                media.mediaType,
                              );
                            },
                          )
                        : _buildGridPlaceholderPoster(media.mediaType),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              media.mediaType == 'movie'
                                  ? Icons.movie
                                  : Icons.tv,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              media.mediaType == 'movie' ? 'Movie' : 'TV Show',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          media.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
              onPressed: () async {
                await ref
                    .read(userProvider.notifier)
                    .toggleFavorite(media.id, media.mediaType);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLoadingItem() {
    return Card(
      color: Colors.grey[900],
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    color: Colors.grey[700],
                    margin: const EdgeInsets.only(bottom: 4),
                  ),
                  Container(height: 12, width: 60, color: Colors.grey[700]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridErrorItem(int mediaId, WidgetRef ref, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final tempMedia = MovieModel(
          id: mediaId,
          title: 'Media $mediaId',
          overview: '',
          posterPath: null,
          releaseDate: '',
          voteAverage: 0.0,
          voteCount: 0,
          mediaType: 'movie', // نستخدم movie كافتراضي
          genreIds: [],
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(item: tempMedia),
          ),
        );
      },
      child: Card(
        color: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white54, size: 40),
            const SizedBox(height: 8),
            Text(
              'Media $mediaId',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () async {
                await ref
                    .read(userProvider.notifier)
                    .toggleFavorite(mediaId, 'movie');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridPlaceholderPoster(String mediaType) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(
          mediaType == 'movie' ? Icons.movie : Icons.tv,
          color: Colors.white54,
          size: 40,
        ),
      ),
    );
  }
}
