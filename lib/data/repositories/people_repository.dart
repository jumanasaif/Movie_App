import '../models/person_model.dart';
import '../services/api_service.dart';

class PeopleRepository {
  final ApiService _api = ApiService();

  Future<List<PersonModel>> getPopularPeople(int page) async {
    final response = await _api.fetchPersons(
      '/person/popular',
      params: {'page': page.toString()},
    );

    return (response['results'] as List)
        .map((e) => PersonModel.fromJson(e))
        .toList();
  }

  Future<List<PersonModel>> searchPeople(String query, int page) async {
    final response = await _api.fetchPersons(
      '/search/person',
      params: {
        'query': query,
        'page': page.toString(),
        'include_adult': 'false',
      },
    );

    return (response['results'] as List)
        .map((e) => PersonModel.fromJson(e))
        .toList();
  }
}
