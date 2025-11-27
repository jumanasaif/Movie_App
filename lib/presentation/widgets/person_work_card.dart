import 'package:flutter/material.dart';

class PersonWorkCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;

  const PersonWorkCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 190,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
