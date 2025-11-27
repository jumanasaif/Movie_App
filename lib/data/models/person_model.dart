class PersonModel {
  final int id;
  final String name;
  final String profilePath;
  final String knownForDepartment;
  final double popularity;

  PersonModel({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.popularity,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      knownForDepartment: json['known_for_department'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }

  String get fullImage => profilePath.isEmpty
      ? 'https://via.placeholder.com/300x400?text=No+Image'
      : 'https://image.tmdb.org/t/p/w500$profilePath';
}
