/// Model class representing a Post from the JSONPlaceholder API.
/// Each Post has: id, userId, title, and body.
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Factory constructor: converts a JSON map → Post object.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Converts Post object → JSON map (used for POST requests).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, title: $title)';
  }
}
