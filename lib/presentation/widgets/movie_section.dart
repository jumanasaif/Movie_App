import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/presentation/widgets/movie_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<MovieModel> data;
  final ScrollController controller;

  const MovieSection({
    super.key,
    required this.title,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return MovieCard(item: item, width: 150);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
