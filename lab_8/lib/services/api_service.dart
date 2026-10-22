import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

/// Service quản lý việc gọi API (Service Layer Pattern - Lab 8.4)
/// Tách biệt hoàn toàn việc gọi mạng ra khỏi giao diện UI.
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Lab 8.1 & 8.2: Lấy danh sách tất cả bài viết (GET /posts)
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      // Giải mã JSON thành List
      final List<dynamic> jsonList = jsonDecode(response.body);
      // Chuyển từng phần tử JSON thành Post object
      return jsonList.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải bài viết. Mã lỗi: ${response.statusCode}');
    }
  }

  /// Lab 8 Bonus: Gửi bài viết mới lên server (POST /posts)
  static Future<Post> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      // Server trả về bài viết vừa tạo (kèm ID mới = 101)
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể tạo bài viết mới. Mã lỗi: ${response.statusCode}');
    }
  }
}
