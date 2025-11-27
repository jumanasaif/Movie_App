import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/video.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailVideos extends ConsumerWidget {
  final AsyncValue<List<Video>> videosAsync;
  final String mediaType;

  const DetailVideos({
    super.key,
    required this.videosAsync,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return videosAsync.when(
      loading: () => _buildLoading(context),
      error: (error, stack) => const SizedBox(),
      data: (videos) {
        final youtubeVideos = videos.where((v) => v.site == 'YouTube').toList();

        if (youtubeVideos.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Videos',
              style: TextStyle(
                color: Colors.white,
                fontSize: _getTitleSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _getSpacing(context)),
            SizedBox(
              height: _getVideoHeight(context),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: youtubeVideos.length,
                itemBuilder: (context, index) {
                  final video = youtubeVideos[index];
                  return _buildVideoItem(context, video);
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
          'Videos',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getTitleSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _getSpacing(context)),
        SizedBox(
          height: _getVideoHeight(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: _getVideoWidth(context),
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

  Widget _buildVideoItem(BuildContext context, Video video) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(video.youtubeUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: _getVideoWidth(context),
        margin: EdgeInsets.only(right: _getSpacing(context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900,
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  "https://img.youtube.com/vi/${video.key}/0.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.amber,
                        size: _getIconSize(context) * 2,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_getPadding(context)),
              child: Text(
                video.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getVideoTextSize(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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

  double _getVideoHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 200;
    if (width > 800) return 180;
    return 160;
  }

  double _getVideoWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 280;
    if (width > 800) return 240;
    if (width > 600) return 220;
    return 200;
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 24;
    return 20;
  }

  double _getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 12;
    return 8;
  }

  double _getVideoTextSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 14;
    return 12;
  }
}
