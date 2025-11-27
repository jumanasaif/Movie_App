class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final List<Genre> genres;
  final int? runtime;
  final String? status;
  final String? tagline;
  final int? budget;
  final int? revenue;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final String mediaType;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.genres,
    required this.mediaType,
    this.posterPath,
    this.backdropPath,
    this.runtime,
    this.status,
    this.tagline,
    this.budget,
    this.revenue,
    this.productionCompanies = const [],
    this.productionCountries = const [],
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json, String mediaType) {
    return MovieDetails(
      id: json['id'] ?? 0,
      title: mediaType == 'movie'
          ? json['title'] ?? 'No Title'
          : json['name'] ?? 'No Title',
      overview: json['overview'] ?? 'No description available',
      releaseDate: mediaType == 'movie'
          ? json['release_date'] ?? 'Unknown'
          : json['first_air_date'] ?? 'Unknown',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      budget: json['budget'],
      revenue: json['revenue'],
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => Genre.fromJson(g))
              .toList() ??
          [],
      productionCompanies:
          (json['production_companies'] as List<dynamic>?)
              ?.map((c) => ProductionCompany.fromJson(c))
              .toList() ??
          [],
      productionCountries:
          (json['production_countries'] as List<dynamic>?)
              ?.map((c) => ProductionCountry.fromJson(c))
              .toList() ??
          [],
      mediaType: mediaType,
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class ProductionCompany {
  final int id;
  final String name;
  final String? logoPath;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoPath: json['logo_path'],
      originCountry: json['origin_country'] ?? '',
    );
  }
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
