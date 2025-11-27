import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/widgets/media_details/rating_dialog.dart';
import 'package:movie_app/providers/user_provider.dart';

class DetailAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final MovieModel item;
  final double? currentUserRating;
  final Function(double?) onRatingUpdated;

  const DetailAppBar({
    super.key,
    required this.item,
    required this.currentUserRating,
    required this.onRatingUpdated,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<DetailAppBar> createState() => _DetailAppBarState();
}

class _DetailAppBarState extends ConsumerState<DetailAppBar> {
  bool _isRating = false;

  Future<void> _submitRating(double rating) async {
    if (_isRating) return;

    setState(() {
      _isRating = true;
    });

    try {
      await ref
          .read(userProvider.notifier)
          .addRating(widget.item.id, widget.item.mediaType, rating);

      widget.onRatingUpdated(rating);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rated ${rating.toStringAsFixed(1)}/10'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to rate: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isRating = false;
      });
    }
  }

  Future<void> _deleteRating() async {
    if (_isRating) return;

    setState(() {
      _isRating = true;
    });

    try {
      await ref
          .read(userProvider.notifier)
          .deleteRating(widget.item.id, widget.item.mediaType);
      widget.onRatingUpdated(null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating removed'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove rating: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isRating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final userAsync = ref.watch(userProvider);

            return userAsync.when(
              data: (user) {
                if (user == null) return const SizedBox();

                final isFav = user.favorites.contains(widget.item.id);

                return Row(
                  children: [
                    if (widget.currentUserRating != null) ...[
                      IconButton(
                        icon: _isRating
                            ? const CircularProgressIndicator(
                                color: Colors.amber,
                                strokeWidth: 2,
                              )
                            : Stack(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: _getIconSize(context),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Text(
                                      widget.currentUserRating!.toStringAsFixed(
                                        0,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _getFontSize(context, 10),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        onPressed: _isRating ? null : _deleteRating,
                        tooltip:
                            'Remove your ${widget.currentUserRating!.toStringAsFixed(1)} rating',
                      ),
                    ] else ...[
                      IconButton(
                        icon: _isRating
                            ? const CircularProgressIndicator(
                                color: Colors.amber,
                                strokeWidth: 2,
                              )
                            : Icon(
                                Icons.star_border,
                                color: Colors.amber,
                                size: _getIconSize(context),
                              ),
                        onPressed: _isRating
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => RatingDialog(
                                    currentRating: widget.currentUserRating,
                                    mediaType: widget.item.mediaType,
                                    onSubmit: _submitRating,
                                  ),
                                );
                              },
                        tooltip:
                            'Rate this ${widget.item.mediaType == 'movie' ? 'movie' : 'TV show'}',
                      ),
                    ],
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: _getIconSize(context),
                      ),
                      onPressed: () {
                        ref
                            .read(userProvider.notifier)
                            .toggleFavorite(
                              widget.item.id,
                              widget.item.mediaType,
                            );
                      },
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
            );
          },
        ),
      ],
    );
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 32;
    return 28;
  }

  double _getFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return baseSize * 1.2;
    return baseSize;
  }
}
