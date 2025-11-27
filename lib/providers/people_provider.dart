import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/person_model.dart';
import 'package:movie_app/data/repositories/people_repository.dart';

final peopleRepositoryProvider = Provider((ref) => PeopleRepository());

class PeopleState {
  final List<PersonModel> people;
  final bool isLoading;
  final bool hasMore;
  final String error;

  PeopleState({
    required this.people,
    required this.isLoading,
    required this.hasMore,
    required this.error,
  });

  PeopleState copyWith({
    List<PersonModel>? people,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return PeopleState(
      people: people ?? this.people,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class PeopleNotifier extends StateNotifier<PeopleState> {
  final PeopleRepository repo;

  int _page = 1;

  PeopleNotifier(this.repo)
    : super(
        PeopleState(people: [], isLoading: false, hasMore: true, error: ''),
      ) {
    loadMore();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final people = await repo.getPopularPeople(_page);

      if (people.isEmpty) {
        state = state.copyWith(isLoading: false, hasMore: false);
      } else {
        state = state.copyWith(
          people: [...state.people, ...people],
          isLoading: false,
        );
        _page++;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load people');
    }
  }
}

final popularPeopleProvider =
    StateNotifierProvider.autoDispose<PeopleNotifier, PeopleState>(
      (ref) => PeopleNotifier(ref.read(peopleRepositoryProvider)),
    );
