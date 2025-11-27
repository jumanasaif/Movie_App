import 'package:flutter/material.dart';
import 'package:movie_app/data/models/person_model.dart';

class PersonCard extends StatelessWidget {
  final PersonModel person;

  const PersonCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            person.fullImage,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          person.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          person.knownForDepartment,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }
}
