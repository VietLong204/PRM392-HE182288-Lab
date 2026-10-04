import 'package:flutter/material.dart';

/// Exercise 1: Core Widgets (Text, Image, Icon, Card, ListTile)
/// Màn hình minh họa các widget hiển thị cơ bản trong Flutter.
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 – Core Widgets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Headline Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 2. Icon using Material Icons
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.movie_creation_rounded,
                size: 64,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),

            // 3. Image.network() với bo góc thẩm mỹ
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                // Hiển thị loading & fallback khi tải ảnh
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 4. Card containing a ListTile
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.star,
                  color: Colors.black54,
                ),
                title: Text(
                  'Movie Item',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'This is a sample ListTile inside a Card.',
                  style: TextStyle(color: Colors.black54),
                ),
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
      home: CoreWidgetsDemo(),
    ),
  );
}
