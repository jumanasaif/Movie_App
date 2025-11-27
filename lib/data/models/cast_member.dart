class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      character: json['character'] ?? 'Unknown',
      profilePath: json['profile_path'],
      order: json['order'] ?? 999,
    );
  }

  String get profileUrl => profilePath?.isNotEmpty == true
      ? 'https://image.tmdb.org/t/p/w200$profilePath'
      : 'https://placehold.co/200x300?text=No+Image';
}
