import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/models/user_model.dart';
import 'package:movie_app/data/repositories/user_repository.dart';
import 'package:movie_app/data/services/api_service.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final UserRepository repo;

  UserNotifier(this.repo) : super(const AsyncValue.loading()) {
    loadUser();
  }

  Future<void> loadUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await repo.getLoggedUser();

      if (user != null) {
        if (user.tmdbGuestSessionId == null) {
          await _createGuestSession(user);
        } else {
          final isValid = await ApiService.validateGuestSession(
            user.tmdbGuestSessionId!,
          );
          if (!isValid) {
            await _createGuestSession(user);
          } else {
            await _syncRatingsWithTMDB(user);
          }
        }
      }

      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _createGuestSession(UserModel user) async {
    try {
      final guestSessionId = await ApiService.createGuestSession();
      if (guestSessionId == null) {
        throw Exception('Failed to create TMDB guest session');
      }

      final updatedUser = UserModel(
        name: user.name,
        email: user.email,
        country: user.country,
        age: user.age,
        password: user.password,
        favorites: user.favorites,
        ratings: user.ratings,
        tmdbGuestSessionId: guestSessionId,
      );

      await updateUser(updatedUser);
      print('Created new guest session: $guestSessionId');
    } catch (e) {
      print('Error creating guest session: $e');
    }
  }

  Future<void> _syncRatingsWithTMDB(UserModel user) async {
    try {
      if (user.tmdbGuestSessionId == null) return;

      final ratedMovies = await ApiService.getRatedMovies(
        guestSessionId: user.tmdbGuestSessionId!,
      );

      for (final movie in ratedMovies) {
        final movieId = movie['id'] as int;
        final rating = (movie['rating'] as num).toDouble();
        user.setRating(movieId, 'movie', rating);
      }

      final ratedTVShows = await ApiService.getRatedTVShows(
        guestSessionId: user.tmdbGuestSessionId!,
      );

      for (final tvShow in ratedTVShows) {
        final tvId = tvShow['id'] as int;
        final rating = (tvShow['rating'] as num).toDouble();
        user.setRating(tvId, 'tv', rating);
      }

      await updateUser(user);
    } catch (e) {
      print('Error syncing ratings: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    final currentState = state;
    if (currentState is AsyncData) {
      state = AsyncValue.data(user);
    }

    try {
      await repo.register(user);
    } catch (e) {
      print('Error updating user in storage: $e');
    }
  }

  Future<void> toggleFavorite(int mediaId, String mediaType) async {
    final currentState = state;
    if (currentState is! AsyncData || currentState.value == null) return;

    final user = currentState.value!;
    final isFav = user.favorites.contains(mediaId);

    try {
      final updatedUser = UserModel(
        name: user.name,
        email: user.email,
        country: user.country,
        age: user.age,
        password: user.password,
        favorites: List.from(user.favorites),
        ratings: user.ratings,
        tmdbGuestSessionId: user.tmdbGuestSessionId,
      );

      if (isFav) {
        updatedUser.favorites.remove(mediaId);
      } else {
        updatedUser.favorites.add(mediaId);
      }

      await updateUser(updatedUser);

      print(
        'Favorite ${isFav ? 'removed' : 'added'} locally for $mediaType $mediaId',
      );
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  bool isFavorite(int movieId) {
    final user = state.value;
    if (user == null) return false;
    return user.favorites.contains(movieId);
  }

  Future<bool> register(UserModel user) async {
    try {
      final exists = await repo.emailExists(user.email);
      if (exists) {
        throw Exception('Email already exists');
      }

      final guestSessionId = await ApiService.createGuestSession();

      final userWithGuestSession = UserModel(
        name: user.name,
        email: user.email,
        country: user.country,
        age: user.age,
        password: user.password,
        favorites: user.favorites,
        ratings: user.ratings,
        tmdbGuestSessionId: guestSessionId,
      );

      await repo.register(userWithGuestSession);
      state = AsyncValue.data(userWithGuestSession);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await repo.login(email, password);

      if (user == null) {
        state = const AsyncValue.data(null);
        return false;
      }

      if (user.tmdbGuestSessionId == null) {
        await _createGuestSession(user);
        final updatedUser = await repo.getLoggedUser();
        state = AsyncValue.data(updatedUser);
      } else {
        final isValid = await ApiService.validateGuestSession(
          user.tmdbGuestSessionId!,
        );
        if (!isValid) {
          await _createGuestSession(user);
          final updatedUser = await repo.getLoggedUser();
          state = AsyncValue.data(updatedUser);
        } else {
          await _syncRatingsWithTMDB(user);
          state = AsyncValue.data(user);
        }
      }

      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await repo.logout();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addRating(int mediaId, String mediaType, double rating) async {
    final currentState = state;
    if (currentState is! AsyncData || currentState.value == null) return;

    final user = currentState.value!;

    if (user.tmdbGuestSessionId == null) {
      final updatedUser = UserModel(
        name: user.name,
        email: user.email,
        country: user.country,
        age: user.age,
        password: user.password,
        favorites: user.favorites,
        ratings: Map.from(user.ratings),
        tmdbGuestSessionId: user.tmdbGuestSessionId,
      );

      updatedUser.setRating(mediaId, mediaType, rating);
      await updateUser(updatedUser);
      return;
    }

    try {
      final success = await ApiService.addRating(
        guestSessionId: user.tmdbGuestSessionId!,
        mediaId: mediaId,
        mediaType: mediaType,
        rating: rating,
      );

      if (success) {
        final updatedUser = UserModel(
          name: user.name,
          email: user.email,
          country: user.country,
          age: user.age,
          password: user.password,
          favorites: user.favorites,
          ratings: Map.from(user.ratings),
          tmdbGuestSessionId: user.tmdbGuestSessionId,
        );

        updatedUser.setRating(mediaId, mediaType, rating);
        await updateUser(updatedUser);
      } else {
        throw Exception('Failed to add rating on TMDB');
      }
    } catch (e) {
      print('Error adding rating: $e');
      final updatedUser = UserModel(
        name: user.name,
        email: user.email,
        country: user.country,
        age: user.age,
        password: user.password,
        favorites: user.favorites,
        ratings: Map.from(user.ratings),
        tmdbGuestSessionId: user.tmdbGuestSessionId,
      );

      updatedUser.setRating(mediaId, mediaType, rating);
      await updateUser(updatedUser);
    }
  }

  Future<void> deleteRating(int mediaId, String mediaType) async {
    final currentState = state;
    if (currentState is! AsyncData || currentState.value == null) return;

    final user = currentState.value!;

    try {
      if (user.tmdbGuestSessionId != null) {
        final success = await ApiService.deleteRating(
          guestSessionId: user.tmdbGuestSessionId!,
          mediaId: mediaId,
          mediaType: mediaType,
        );

        if (!success) {
          print('Failed to delete rating from TMDB, deleting locally only');
        }
      }

      final updatedUser = UserModel(
        name: user.name,
        email: user.email,
        country: user.country,
        age: user.age,
        password: user.password,
        favorites: user.favorites,
        ratings: Map.from(user.ratings),
        tmdbGuestSessionId: user.tmdbGuestSessionId,
      );

      updatedUser.removeRating(mediaId, mediaType);
      await updateUser(updatedUser);
    } catch (e) {
      print('Error deleting rating: $e');
      rethrow;
    }
  }

  double? getRating(int mediaId, String mediaType) {
    final user = state.value;
    if (user == null) return null;
    return user.getRating(mediaId, mediaType);
  }

  bool hasRated(int mediaId, String mediaType) {
    return getRating(mediaId, mediaType) != null;
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
      final repo = ref.watch(userRepositoryProvider);
      return UserNotifier(repo);
    });
