import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/data/models/user_model.dart';
import 'package:movie_app/presentation/screens/media/view_all_movies.dart';
import 'package:movie_app/presentation/widgets/movie_section.dart';
import 'package:movie_app/presentation/widgets/person_card.dart';
import 'package:movie_app/providers/movie_providers.dart';
import 'package:movie_app/providers/people_provider.dart';
import 'package:movie_app/providers/people_search_provider.dart';
import 'package:movie_app/providers/search_filter_provider.dart';
import 'package:movie_app/providers/user_provider.dart';
import 'package:movie_app/providers/bottom_nav_provider.dart'
    hide bottomNavIndexProvider;

class MoviesHome extends ConsumerStatefulWidget {
  const MoviesHome({super.key});

  @override
  ConsumerState<MoviesHome> createState() => _MoviesHomeState();
}

class _MoviesHomeState extends ConsumerState<MoviesHome>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;

  final ScrollController _nowPlayingController = ScrollController();
  final ScrollController _topRatedController = ScrollController();
  final ScrollController _popularController = ScrollController();

  final ScrollController _onAirTvController = ScrollController();
  final ScrollController _topRatedTvController = ScrollController();
  final ScrollController _popularTvController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentRouteProvider.notifier).state = '/';
    });

    _addScrollListener(
      _nowPlayingController,
      () => ref.read(nowPlayingMoviesProvider.notifier).loadMore(),
    );

    _addScrollListener(
      _topRatedController,
      () => ref.read(topRatedMoviesProvider.notifier).loadMore(),
    );

    _addScrollListener(
      _popularController,
      () => ref.read(popularMoviesProvider.notifier).loadMore(),
    );

    _addScrollListener(
      _onAirTvController,
      () => ref.read(onAirTvProvider.notifier).loadMore(),
    );

    _addScrollListener(
      _popularTvController,
      () => ref.read(popularTvProvider.notifier).loadMore(),
    );

    _addScrollListener(
      _topRatedTvController,
      () => ref.read(topRatedTvProvider.notifier).loadMore(),
    );
  }

  void _addScrollListener(
    ScrollController controller,
    VoidCallback onLoadMore,
  ) {
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        onLoadMore();
      }
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final mediaType = _tabController.index == 0
          ? 'movie'
          : _tabController.index == 1
          ? 'tv'
          : 'person';
      ref.read(searchFilterProvider.notifier).setMediaType(mediaType);
    }
  }

  Widget buildViewAllButton(
    BuildContext context,
    String title,
    String mediaType,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 3,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ViewAllMoviesScreen(title: title, mediaType: mediaType),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          label: const Text(
            "View All",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildWelcomeBanner(AsyncValue<UserModel?> userState) {
    return userState.when(
      data: (user) {
        final name = user?.name ?? "Guest";
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(171, 255, 0, 0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            "Welcome, $name 🎬",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (err, _) => const SizedBox.shrink(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nowPlayingController.dispose();
    _topRatedController.dispose();
    _popularController.dispose();
    _onAirTvController.dispose();
    _topRatedTvController.dispose();
    _popularTvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trending = ref.watch(nowPlayingMoviesProvider);
    final topRated = ref.watch(topRatedMoviesProvider);
    final popular = ref.watch(popularMoviesProvider);

    final trendingTv = ref.watch(onAirTvProvider);
    final topRatedTv = ref.watch(topRatedTvProvider);
    final popularTv = ref.watch(popularTvProvider);

    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MovieZone ',
          style: TextStyle(
            color: Colors.amber,
            fontFamily: 'Bilbo',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white),
            offset: const Offset(0, 40),

            onSelected: (value) async {
              if (value == 'logout') {
                await ref.read(userProvider.notifier).logout();

                if (mounted) {
                  context.go('/welcome');
                }
              } else if (value == 'favorite') {
                context.goNamed('favorites');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: const [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Favorites',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Movies'),
              Tab(text: 'TV Shows'),
              Tab(text: 'People'),
            ],
            indicatorColor: Colors.amber,
            labelColor: Colors.white,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Movies Tab
          ListView(
            children: [
              buildWelcomeBanner(userState),
              buildViewAllButton(context, "All Movies", "movie"),
              MovieSection(
                title: 'Now Playing Movies',
                data: trending,
                controller: _nowPlayingController,
              ),
              MovieSection(
                title: 'Top Rated Movies',
                data: topRated,
                controller: _topRatedController,
              ),
              MovieSection(
                title: 'Popular Movies',
                data: popular,
                controller: _popularController,
              ),
            ],
          ),

          // TV Shows Tab
          ListView(
            children: [
              buildWelcomeBanner(userState),
              buildViewAllButton(context, "All TV Shows", "tv"),
              MovieSection(
                title: 'On The Air TV',
                data: trendingTv,
                controller: _onAirTvController,
              ),
              MovieSection(
                title: 'Top Rated TV',
                data: topRatedTv,
                controller: _topRatedTvController,
              ),
              MovieSection(
                title: 'Popular TV',
                data: popularTv,
                controller: _popularTvController,
              ),
            ],
          ),

          // People Tab
          Consumer(
            builder: (context, ref, _) {
              final searchController = TextEditingController();
              final searchFocusNode = FocusNode();

              void onSearchChanged(String value) {
                ref.read(peopleSearchProvider.notifier).searchPeople(value);
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!searchFocusNode.hasFocus &&
                    searchController.text.isEmpty) {
                  ref.read(peopleSearchProvider.notifier).clearSearch();
                }
              });

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search for people...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.amber,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            ref
                                .read(peopleSearchProvider.notifier)
                                .clearSearch();
                            searchFocusNode.unfocus();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final searchQuery = searchController.text.trim();

                        final PeopleSearchState searchState = ref.watch(
                          peopleSearchProvider,
                        );
                        final PeopleState popularState = ref.watch(
                          popularPeopleProvider,
                        );

                        final bool isSearching = searchQuery.isNotEmpty;
                        final dynamic currentState = isSearching
                            ? searchState
                            : popularState;

                        final dynamic currentNotifier = isSearching
                            ? ref.read(peopleSearchProvider.notifier)
                            : ref.read(popularPeopleProvider.notifier);

                        if (currentState.isLoading &&
                            currentState.people.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          );
                        }

                        if (currentState.error.isNotEmpty &&
                            currentState.people.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentState.error,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => currentNotifier.loadMore(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (currentState.people.isEmpty && isSearching) {
                          return const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        return NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 200) {
                              currentNotifier.loadMore();
                            }
                            return false;
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(12),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.55,
                                      ),
                                  itemCount: currentState.people.length,
                                  itemBuilder: (context, i) {
                                    final p = currentState.people[i];
                                    return GestureDetector(
                                      onTap: () {
                                        context.push('/person/${p.id}');
                                      },
                                      child: PersonCard(person: p),
                                    );
                                  },
                                ),
                              ),

                              if (currentState.isLoading &&
                                  currentState.people.isNotEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final index = ref.watch(smartBottomNavProvider);

          return BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              ref.read(bottomNavIndexProvider.notifier).state = value;
              ref.read(currentRouteProvider.notifier).state = value == 0
                  ? '/'
                  : '/profile';

              if (value == 0) {
                context.go('/');
              } else if (value == 1) {
                context.go('/profile');
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.black,
            elevation: 20,
          );
        },
      ),
    );
  }
}
