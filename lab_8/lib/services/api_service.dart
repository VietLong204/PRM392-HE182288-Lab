import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

/// ApiService – Service Layer Pattern (Lab 8.4)
/// Handles all network requests to the JSONPlaceholder API.
/// Separates networking logic from UI code.
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Allows injecting a custom http.Client (useful for testing).
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ─────────────────────────────────────────────
  // Lab 8.1 & 8.2: GET – Fetch all posts
  // ─────────────────────────────────────────────
  /// Fetches the list of posts from the API.
  /// Returns List<Post> on success, throws Exception on failure.
  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');

    // Print raw JSON for verification (Lab 8.1 goal)
    print('[ApiService] GET $uri');

    final response = await _client
        .get(uri, headers: {'Content-Type': 'application/json'})
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timed out. Please check your connection.'),
        );

    print('[ApiService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      // dart:convert – decode JSON response
      final List<dynamic> jsonList = json.decode(response.body);
      // Convert raw JSON list → List<Post>
      final posts = jsonList.map((item) => Post.fromJson(item)).toList();
      print('[ApiService] Parsed ${posts.length} posts');
      return posts;
    } else {
      throw Exception(
        'Failed to load posts. Server returned ${response.statusCode}.',
      );
    }
  }

  // ─────────────────────────────────────────────
  // Optional: POST – Create a new post
  // ─────────────────────────────────────────────
  /// Sends a new post to the API via POST request.
  /// Returns the created Post on success (JSONPlaceholder echoes it back with id: 101).
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');
    print('[ApiService] POST $uri');

    final response = await _client
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'title': title, 'body': body, 'userId': userId}),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timed out.'),
        );

    print('[ApiService] Status: ${response.statusCode}');
    print('[ApiService] Response: ${response.body}');

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to create post. Server returned ${response.statusCode}.',
      );
    }
  }
}
