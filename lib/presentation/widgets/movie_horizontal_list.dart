import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/widgets/movie_card.dart';

class MovieHorizontalList extends StatelessWidget {
  final List<MovieModel> items;
  final ScrollController controller;
  final double itemWidth;

  const MovieHorizontalList({
    super.key,
    required this.items,
    required this.controller,
    this.itemWidth = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final m = items[index];
          return MovieCard(item: m, width: itemWidth);
        },
      ),
    );
  }
}
