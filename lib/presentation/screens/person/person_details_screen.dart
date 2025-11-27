import 'package:flutter/material.dart';
import 'package:movie_app/data/services/api_service.dart';
import 'package:movie_app/presentation/widgets/person_work_card.dart';

class PersonDetailsScreen extends StatefulWidget {
  final int personId;

  const PersonDetailsScreen({super.key, required this.personId});

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  Map<String, dynamic>? data;
  List<dynamic> works = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    final api = ApiService();

    final person = await api.fetchPersons('/person/${widget.personId}');
    final credits = await api.fetchPersons(
      '/person/${widget.personId}/combined_credits',
    );

    setState(() {
      data = person;
      works = credits['cast'] ?? [];
      loading = false;
    });
  }

  Widget infoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 22),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title:",
                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? "Unknown" : value,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = data!['profile_path'] != null
        ? "https://image.tmdb.org/t/p/w500${data!['profile_path']}"
        : "https://via.placeholder.com/300x400?text=No+Image";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(data!['name']), backgroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // image
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(profile, width: 220),
            ),
          ),

          const SizedBox(height: 20),

          //name
          Text(
            data!['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),
          Text(
            data!['known_for_department'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.amber),
          ),

          const SizedBox(height: 24),

          //info section
          const Text(
            "Personal Information",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          infoTile(
            Icons.calendar_today,
            "Birthdate",
            data!['birthday'] ?? "Unknown",
          ),

          const SizedBox(height: 10),

          infoTile(
            Icons.place,
            "Birthplace",
            data!['place_of_birth'] ?? "Unknown",
          ),

          const SizedBox(height: 10),

          infoTile(
            Icons.person,
            "Gender",
            data!['gender'] == 1 ? "Female" : "Male",
          ),

          const SizedBox(height: 10),

          infoTile(Icons.star, "Popularity", data!['popularity'].toString()),

          const SizedBox(height: 30),

          // Works Section
          const Text(
            "Known For",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: works.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final w = works[i];
                final title = w['title'] ?? w['name'] ?? "Unknown";
                final poster = w['poster_path'] != null
                    ? "https://image.tmdb.org/t/p/w200${w['poster_path']}"
                    : "https://via.placeholder.com/200x300?text=No+Image";

                return PersonWorkCard(
                  title: title,
                  imageUrl: poster,
                  rating: w['vote_average']?.toDouble() ?? 0,
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Biography",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            data!['biography'] == ""
                ? "No biography available."
                : data!['biography'],
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
