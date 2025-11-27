import 'package:go_router/go_router.dart';
import 'package:movie_app/presentation/screens/auth/login_screen.dart';
import 'package:movie_app/presentation/screens/auth/signup_screen.dart';
import 'package:movie_app/presentation/screens/media/favorites_screen.dart';
import 'package:movie_app/presentation/screens/media/movies_home.dart';
import 'package:movie_app/presentation/screens/media/view_all_movies.dart';
import 'package:movie_app/presentation/screens/person/person_details_screen.dart';
import 'package:movie_app/presentation/screens/user/profile_page.dart';
import 'package:movie_app/presentation/screens/welcome_screen.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),

      GoRoute(
        name: 'favorites',
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),

      GoRoute(
        path: '/',
        builder: (context, state) => const MoviesHome(),
        routes: [
          GoRoute(
            path: 'view_all',
            builder: (context, state) {
              final title = state.uri.queryParameters['title'] ?? 'All';
              final type = state.uri.queryParameters['type'] ?? 'movie';
              return ViewAllMoviesScreen(title: title, mediaType: type);
            },
          ),
          GoRoute(
            path: '/person/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return PersonDetailsScreen(personId: id);
            },
          ),
        ],
      ),
    ],
  );
}
