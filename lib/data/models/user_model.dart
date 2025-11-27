class UserModel {
  String name;
  String email;
  String country;
  int age;
  String password;
  List<int> favorites;
  Map<String, double> ratings;
  String? tmdbGuestSessionId;

  UserModel({
    required this.name,
    required this.email,
    required this.country,
    required this.age,
    required this.password,
    this.favorites = const [],
    this.ratings = const {},
    this.tmdbGuestSessionId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'country': country,
    'age': age,
    'password': password,
    'favorites': favorites,
    'ratings': ratings,
    'tmdbGuestSessionId': tmdbGuestSessionId,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    country: json['country'] ?? '',
    age: json['age'] ?? 0,
    password: json['password'] ?? '',
    favorites: List<int>.from(json['favorites'] ?? []),
    ratings: _parseRatings(json['ratings']),
    tmdbGuestSessionId: json['tmdbGuestSessionId'],
  );

  static Map<String, double> _parseRatings(dynamic ratingsData) {
    if (ratingsData == null) return {};
    if (ratingsData is Map<String, dynamic>) {
      return ratingsData.map((key, value) {
        if (value is double) {
          return MapEntry(key, value);
        } else if (value is int) {
          return MapEntry(key, value.toDouble());
        } else if (value is String) {
          return MapEntry(key, double.tryParse(value) ?? 0.0);
        } else {
          return MapEntry(key, 0.0);
        }
      });
    }
    return {};
  }

  String _getRatingKey(int mediaId, String mediaType) {
    return '${mediaType}_$mediaId';
  }

  void setRating(int mediaId, String mediaType, double rating) {
    ratings[_getRatingKey(mediaId, mediaType)] = rating;
  }

  void removeRating(int mediaId, String mediaType) {
    ratings.remove(_getRatingKey(mediaId, mediaType));
  }

  double? getRating(int mediaId, String mediaType) {
    return ratings[_getRatingKey(mediaId, mediaType)];
  }
}
