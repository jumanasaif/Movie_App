import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/person_model.dart';
import 'package:movie_app/data/repositories/people_repository.dart';

final peopleSearchRepositoryProvider = Provider((ref) => PeopleRepository());

class PeopleSearchState {
  final List<PersonModel> people;
  final bool isLoading;
  final bool hasMore;
  final String error;

  PeopleSearchState({
    required this.people,
    required this.isLoading,
    required this.hasMore,
    required this.error,
  });

  PeopleSearchState copyWith({
    List<PersonModel>? people,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return PeopleSearchState(
      people: people ?? this.people,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class PeopleSearchNotifier extends StateNotifier<PeopleSearchState> {
  final PeopleRepository repo;
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  String _currentQuery = '';
  int _page = 1;

  PeopleSearchNotifier(this.repo)
    : super(
        PeopleSearchState(
          people: [],
          isLoading: false,
          hasMore: true,
          error: '',
        ),
      );

  void searchPeople(String query) {
    _currentQuery = query.trim();

    if (_currentQuery.isEmpty) {
      state = state.copyWith(
        people: [],
        isLoading: false,
        hasMore: true,
        error: '',
      );
      _page = 1;
      return;
    }

    _debouncer.run(() {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: '');
    _page = 1;

    try {
      final people = await repo.searchPeople(_currentQuery, _page);
      state = state.copyWith(
        people: people,
        isLoading: false,
        hasMore: people.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        people: [],
        isLoading: false,
        error: 'Failed to search people',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore || _currentQuery.isEmpty) return;

    state = state.copyWith(isLoading: true);

    try {
      final people = await repo.searchPeople(_currentQuery, _page + 1);

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
      state = state.copyWith(isLoading: false, error: 'Failed to load more');
    }
  }

  void clearSearch() {
    _currentQuery = '';
    state = state.copyWith(
      people: [],
      isLoading: false,
      hasMore: true,
      error: '',
    );
    _page = 1;
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

final peopleSearchProvider =
    StateNotifierProvider.autoDispose<PeopleSearchNotifier, PeopleSearchState>(
      (ref) => PeopleSearchNotifier(ref.read(peopleSearchRepositoryProvider)),
    );
