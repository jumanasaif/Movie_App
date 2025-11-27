import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/presentation/screens/media/media_details_screen.dart';
import 'package:movie_app/providers/filtered_movies_provider.dart';
import 'package:movie_app/providers/search_filter_provider.dart';

class ViewAllMoviesScreen extends ConsumerStatefulWidget {
  final String title;
  final String mediaType;

  const ViewAllMoviesScreen({
    super.key,
    required this.title,
    required this.mediaType,
  });

  @override
  ConsumerState<ViewAllMoviesScreen> createState() =>
      _ViewAllMoviesScreenState();
}

class _ViewAllMoviesScreenState extends ConsumerState<ViewAllMoviesScreen> {
  late final ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String? _selectedSortBy;
  String? _selectedGenre;

  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchFilterProvider.notifier).setMediaType(widget.mediaType);
    });
  }

  void _onScroll() {
    final provider = widget.mediaType == 'movie'
        ? filteredAllMoviesProvider
        : filteredAllTvProvider;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(provider.notifier).loadMore();
    }
  }

  void _applyFilters() {
    final provider = widget.mediaType == 'movie'
        ? filteredAllMoviesProvider
        : filteredAllTvProvider;

    ref
        .read(provider.notifier)
        .applyFilters(
          query: _searchController.text.trim(),
          sortBy: _selectedSortBy,
          withGenres: _selectedGenre,
          year: _yearController.text.trim().isNotEmpty
              ? _yearController.text.trim()
              : null,
        );
  }

  void _clearFilters() {
    _searchController.clear();
    _yearController.clear();
    _selectedSortBy = null;
    _selectedGenre = null;

    final provider = widget.mediaType == 'movie'
        ? filteredAllMoviesProvider
        : filteredAllTvProvider;

    ref.read(provider.notifier).refresh();
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _yearController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.mediaType == 'movie'
        ? filteredAllMoviesProvider
        : filteredAllTvProvider;

    final items = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    'Search ${widget.mediaType == 'movie' ? 'movies' : 'TV shows'}...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (_) => _applyFilters(),
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: items.length,
                    itemBuilder: (c, i) {
                      final m = items[i];
                      return ListTile(
                        leading: m.posterPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w92${m.posterPath}',
                                  width: 40,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 40,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.movie,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                width: 40,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.movie,
                                  color: Colors.grey,
                                ),
                              ),
                        title: Text(
                          m.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.releaseDate?.isNotEmpty == true
                                  ? m.releaseDate!
                                  : 'No release date',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  m.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(item: items[i]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Filters'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year
                  TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      hintText: '2023',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Sort By
                  DropdownButtonFormField<String>(
                    value: _selectedSortBy,
                    decoration: const InputDecoration(labelText: 'Sort By'),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          'Default',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      ...[
                        'popularity.desc',
                        'popularity.asc',
                        'release_date.desc',
                        'release_date.asc',
                        'vote_average.desc',
                        'vote_average.asc',
                        'vote_count.desc',
                        'vote_count.asc',
                        'original_title.asc',
                        'original_title.desc',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(_getSortByDisplayName(value)),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedSortBy = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  Text(
                    _getSortingInfoText(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearFilters();
                },
                child: const Text('Clear All'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getSortByDisplayName(String sortBy) {
    switch (sortBy) {
      case 'popularity.desc':
        return 'Most Popular';
      case 'popularity.asc':
        return 'Least Popular';
      case 'release_date.desc':
        return 'Newest First';
      case 'release_date.asc':
        return 'Oldest First';
      case 'vote_average.desc':
        return 'Highest Rating';
      case 'vote_average.asc':
        return 'Lowest Rating';
      case 'vote_count.desc':
        return 'Most Votes';
      case 'vote_count.asc':
        return 'Least Votes';
      case 'original_title.asc':
        return 'Title (A-Z)';
      case 'original_title.desc':
        return 'Title (Z-A)';
      default:
        return sortBy;
    }
  }

  String _getSortingInfoText() {
    if (_selectedSortBy == 'vote_average.desc') {
      return 'Shows highest rated content first';
    } else if (_selectedSortBy == 'vote_average.asc') {
      return 'Shows lowest rated content first';
    } else if (_selectedSortBy == 'release_date.desc') {
      return 'Shows newest content first';
    } else if (_selectedSortBy == 'release_date.asc') {
      return 'Shows oldest content first';
    }
    return 'Content will be sorted based on your selection';
  }
}
