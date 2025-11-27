class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
    );
  }

  String get youtubeUrl =>
      site == 'YouTube' ? 'https://www.youtube.com/watch?v=$key' : '';
}
