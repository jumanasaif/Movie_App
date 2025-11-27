import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_app_bar.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_body.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_loading.dart';
import 'package:movie_app/presentation/widgets/media_details/detail_error.dart';
import 'package:movie_app/providers/media_details_provider.dart';
import 'package:movie_app/providers/user_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final MovieModel item;

  const DetailScreen({super.key, required this.item});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  double? _currentUserRating;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  void _loadUserRating() {
    final user = ref.read(userProvider).value;
    if (user != null) {
      _currentUserRating = user.getRating(
        widget.item.id,
        widget.item.mediaType,
      );
    }
  }

  void _onRatingUpdated(double? rating) {
    setState(() {
      _currentUserRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(
      mediaDetailsProvider((
        id: widget.item.id,
        mediaType: widget.item.mediaType,
      )),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: DetailAppBar(
        item: widget.item,
        currentUserRating: _currentUserRating,
        onRatingUpdated: _onRatingUpdated,
      ),
      body: detailsAsync.when(
        loading: () => const DetailLoading(),
        error: (error, stack) => DetailError(error: error, item: widget.item),
        data: (details) => DetailBody(
          details: details,
          item: widget.item,
          currentUserRating: _currentUserRating,
        ),
      ),
    );
  }
}
