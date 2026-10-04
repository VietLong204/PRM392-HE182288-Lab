// Lab 6 – Building a Responsive Movie Genre Browsing Screen
// Single-file Flutter demo (no third-party packages).
// Paste into DartPad (New Flutter) or replace lib/main.dart in a Flutter project.

import 'package:flutter/material.dart';

void main() => runApp(const ResponsiveMovieApp());

/// ---------------------------------------------------------------------------
/// Step 2 – Movie model & sample data
/// ---------------------------------------------------------------------------
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/inception/300/450',
    rating: 8.8,
  ),
  Movie(
    title: 'The Shawshank Redemption',
    year: 1994,
    genres: ['Drama'],
    posterUrl: 'https://picsum.photos/seed/shawshank/300/450',
    rating: 9.3,
  ),
  Movie(
    title: 'Superbad',
    year: 2007,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/superbad/300/450',
    rating: 7.6,
  ),
  Movie(
    title: 'Mad Max: Fury Road',
    year: 2015,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/madmax/300/450',
    rating: 8.1,
  ),
  Movie(
    title: 'Get Out',
    year: 2017,
    genres: ['Horror', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/getout/300/450',
    rating: 7.8,
  ),
  Movie(
    title: 'La La Land',
    year: 2016,
    genres: ['Drama', 'Romance', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/lalaland/300/450',
    rating: 8.0,
  ),
];

const List<String> allGenres = [
  'Action',
  'Adventure',
  'Comedy',
  'Drama',
  'Horror',
  'Romance',
  'Sci-Fi',
  'Thriller',
];

const List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

/// Width (px) at which the layout switches from 1 column to 2 columns.
const double kTabletBreakpoint = 800;

/// ---------------------------------------------------------------------------
/// Step 3 – Base app
/// ---------------------------------------------------------------------------
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // State (Steps 4, 5, 6)
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Step 7 – filter by search text + genres, then sort.
  List<Movie> get visibleMovies {
    final query = searchQuery.trim().toLowerCase();

    final result = allMovies.where((movie) {
      final matchesSearch =
          query.isEmpty || movie.title.toLowerCase().contains(query);
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    switch (selectedSort) {
      case 'A-Z':
        result.sort((a, b) =>
            a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'Z-A':
        result.sort((a, b) =>
            b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case 'Year': // newest first
        result.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating': // highest first
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return result;
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || selectedGenres.isNotEmpty;

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery: read screen size to scale the heading and cap header height.
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= kTabletBreakpoint;
    final movies = visibleMovies;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 32 : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header area (scrollable if the screen is very short,
              // e.g. phone in landscape) so it never overflows.
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height * 0.5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find a Movie',
                        style: TextStyle(
                          fontSize: isWide ? 36 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildGenreHeader(),
                      const SizedBox(height: 8),
                      _buildGenreChips(),
                      const SizedBox(height: 12),
                      _buildSortRow(movies.length),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Step 8 – responsive list/grid takes the remaining space.
              Expanded(child: _buildMovieArea(movies)),
            ],
          ),
        ),
      ),
    );
  }

  /// Step 4 – search bar in a rounded container.
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search movie title...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => searchQuery = '');
                  },
                ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  /// "Genres" label + badge with selected count + Clear filters button (bonus).
  Widget _buildGenreHeader() {
    return Row(
      children: [
        const Text(
          'Genres',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        if (selectedGenres.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${selectedGenres.length}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (hasActiveFilters)
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear filters'),
          ),
      ],
    );
  }

  /// Step 5 – genre chips using Wrap (wraps automatically).
  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: allGenres.map((genre) {
        final isSelected = selectedGenres.contains(genre);
        return FilterChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              if (isSelected) {
                selectedGenres.remove(genre);
              } else {
                selectedGenres.add(genre);
              }
            });
          },
        );
      }).toList(),
    );
  }

  /// Step 6 – sort dropdown (+ result count).
  Widget _buildSortRow(int count) {
    return Row(
      children: [
        Text('$count result${count == 1 ? '' : 's'}',
            style: TextStyle(color: Colors.grey.shade700)),
        const Spacer(),
        const Text('Sort by: '),
        DropdownButton<String>(
          value: selectedSort,
          underline: const SizedBox.shrink(),
          items: sortOptions
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => selectedSort = value);
          },
        ),
      ],
    );
  }

  /// Step 8 – LayoutBuilder decides 1 column (ListView) vs 2 columns (GridView).
  Widget _buildMovieArea(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter_outlined,
                size: 56, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            const Text('No movies match your filters.'),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (maxWidth < kTabletBreakpoint) {
          // Small screens: single column.
          final cardHeight = MovieCard.heightFor(maxWidth);
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                height: cardHeight,
                child: MovieCard(movie: movies[index], width: maxWidth),
              ),
            ),
          );
        }

        // Wide screens: two columns.
        const spacing = 16.0;
        final itemWidth = (maxWidth - spacing) / 2;
        final cardHeight = MovieCard.heightFor(itemWidth);
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: itemWidth / cardHeight,
          children: movies
              .map((m) => MovieCard(movie: m, width: itemWidth))
              .toList(),
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// Movie card – poster size adapts to the width the card is given.
/// ---------------------------------------------------------------------------
class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;

  const MovieCard({super.key, required this.movie, required this.width});

  static const double _padding = 12;

  /// Poster width: ~28% of card width, clamped between 70 and 120 px.
  static double posterWidthFor(double cardWidth) =>
      (cardWidth * 0.28).clamp(70.0, 120.0);

  /// Poster uses a 2:3 aspect ratio; card height = poster + vertical padding.
  static double heightFor(double cardWidth) =>
      posterWidthFor(cardWidth) * 1.5 + _padding * 2;

  @override
  Widget build(BuildContext context) {
    final posterW = posterWidthFor(width);
    final posterH = posterW * 1.5;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Row(
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: posterW,
                height: posterH,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.movie, size: 32),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('${movie.year}',
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.genres.join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}