class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final List<int> genreIds;
  final String mediaType;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.mediaType,
    this.posterPath,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, String mediaType) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: mediaType == 'movie'
          ? (json['title'] ?? 'No Title')
          : (json['name'] ?? 'No Title'),
      overview: json['overview'] ?? '',
      releaseDate: mediaType == 'movie'
          ? (json['release_date'] ?? '')
          : (json['first_air_date'] ?? ''),
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      posterPath: json['poster_path'],
      genreIds:
          (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      mediaType: mediaType,
    );
  }
}
