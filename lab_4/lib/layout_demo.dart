import 'package:flutter/material.dart';
/// Exercise 3: Layout Basics (Column, Row, Padding, ListView)
/// Màn hình bố cục danh sách phim với layout có cấu trúc rõ ràng.
class MovieItem {
  final String title;
  final String description;

  const MovieItem({required this.title, required this.description});
}

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<MovieItem> _movies = const [
    MovieItem(title: 'Avatar', description: 'Sample description'),
    MovieItem(title: 'Inception', description: 'Sample description'),
    MovieItem(title: 'Interstellar', description: 'Sample description'),
    MovieItem(title: 'Joker', description: 'Sample description'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tiêu đề phần (Section Header)
            const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách hiển thị bằng ListView.builder bên trong Expanded
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  final initial = movie.title.isNotEmpty
                      ? movie.title[0].toUpperCase()
                      : '?';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade50,
                          foregroundColor: Colors.deepPurple.shade400,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          movie.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Hàm main để có thể chạy độc lập file này
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutDemo(),
    ),
  );
}
