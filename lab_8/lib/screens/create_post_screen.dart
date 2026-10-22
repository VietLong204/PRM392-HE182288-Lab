import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

/// Màn hình thêm bài viết mới (Lab 8 - POST Request)
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  bool _isLoading = false;
  Post? _createdPost;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // Hàm xử lý gửi POST request khi bấm nút Tạo bài viết
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final post = await ApiService.createPost(
        _titleController.text.trim(),
        _bodyController.text.trim(),
      );

      setState(() {
        _createdPost = post;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo bài viết thành công! (Mã: 201)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo bài viết mới (POST)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ô nhập Tiêu đề
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề bài viết',
                  hintText: 'Nhập tiêu đề...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ô nhập Nội dung
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Nội dung bài viết',
                  hintText: 'Nhập nội dung...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nút Gửi bài viết
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Gửi bài viết', style: TextStyle(fontSize: 16)),
              ),

              // Hiển thị kết quả trả về từ Server nếu tạo thành công
              if (_createdPost != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✅ Kết quả từ server (POST response):',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('ID: ${_createdPost!.id}'),
                        Text('Tiêu đề: ${_createdPost!.title}'),
                        Text('Nội dung: ${_createdPost!.body}'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
