import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';

/// Màn hình chính của Lab 8:
/// - Lab 8.1: Gọi GET API bằng http
/// - Lab 8.2: Parse JSON thành `List<Post>` và hiển thị bằng ListView.builder
/// - Lab 8.3: Xử lý trạng thái Loading & Error với FutureBuilder
/// - Lab 8.4: Áp dụng Service Layer (ApiService)
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  // Biến lưu trữ Future chứa danh sách bài viết
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  // Hàm tải dữ liệu từ API
  void _loadPosts() {
    setState(() {
      _postsFuture = ApiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài viết (Lab 8)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
            tooltip: 'Tải lại',
          ),
        ],
      ),
      // Nút Floating Action Button để chuyển sang màn hình thêm bài viết mới
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      // Sử dụng FutureBuilder để xử lý 3 trạng thái: Đang tải, Lỗi, Thành công
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // TRẠNG THÁI 1: Đang tải dữ liệu (Loading state)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải danh sách bài viết...'),
                ],
              ),
            );
          }

          // TRẠNG THÁI 2: Xảy ra lỗi (Error state)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadPosts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // TRẠNG THÁI 3: Tải thành công (Data state)
          if (snapshot.hasData) {
            final posts = snapshot.data!;

            if (posts.isEmpty) {
              return const Center(child: Text('Không có bài viết nào.'));
            }

            // Kéo xuống để tải lại (Pull-to-refresh) + ListView.builder
            return RefreshIndicator(
              onRefresh: () async {
                _loadPosts();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      // Vòng tròn hiển thị ID bài viết
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '${post.id}',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Tiêu đề bài viết
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Nội dung rút gọn (tối đa 2 dòng)
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      // Bấm vào để xem màn hình chi tiết
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
