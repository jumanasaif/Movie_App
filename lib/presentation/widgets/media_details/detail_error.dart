import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/providers/media_details_provider.dart';

class DetailError extends ConsumerWidget {
  final Object error;
  final MovieModel item;

  const DetailError({super.key, required this.error, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: isLargeScreen ? 80 : 64),
            SizedBox(height: isLargeScreen ? 24 : 16),
            Text(
              'Error loading details',
              style: TextStyle(
                color: Colors.white,
                fontSize: isLargeScreen ? 22 : 18,
              ),
            ),
            SizedBox(height: isLargeScreen ? 16 : 8),
            Text(
              error.toString(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: isLargeScreen ? 16 : 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isLargeScreen ? 24 : 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(
                mediaDetailsProvider((id: item.id, mediaType: item.mediaType)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 32 : 24,
                  vertical: isLargeScreen ? 16 : 12,
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isLargeScreen ? 18 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
