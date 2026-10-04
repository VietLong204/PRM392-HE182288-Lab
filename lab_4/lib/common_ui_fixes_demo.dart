import 'package:flutter/material.dart';

/// Exercise 5: Debug & Fix Common UI Errors
/// 1. Fix ListView inside Column using Expanded (Unbounded height fix)
/// 2. Fix overflow in small screens using SingleChildScrollView (RenderFlex overflow fix)
/// 3. Fix state update issue by adding setState() (Reactive UI fix)
/// 4. Fix DatePicker build context errors by calling from valid widget tree (Valid BuildContext fix)
class CommonUiFixesDemo extends StatefulWidget {
  const CommonUiFixesDemo({super.key});

  @override
  State<CommonUiFixesDemo> createState() => _CommonUiFixesDemoState();
}

class _CommonUiFixesDemoState extends State<CommonUiFixesDemo> {
  int _counter = 0;
  DateTime? _pickedDate;

  final List<String> _movies = const [
    'Movie A',
    'Movie B',
    'Movie C',
    'Movie D',
  ];

  // Fix 4: Gọi DatePicker với context hợp lệ từ widget tree
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      // Fix 3: Luôn gọi setState để cập nhật UI khi state thay đổi
      setState(() {
        _pickedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
      ),
      // Fix 2: Dùng SingleChildScrollView hoặc cấu trúc hợp lý để tránh lỗi RenderFlex overflow trên màn hình nhỏ
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task 1: Tiêu đề sửa lỗi ListView trong Column
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Task 1: Fix ListView inside Column using Expanded
            // (Nếu không bọc Expanded, ListView trong Column sẽ gây lỗi "Vertical viewport was given unbounded height")
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.movie,
                      color: Colors.black54,
                      size: 26,
                    ),
                    title: Text(
                      _movies[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            // Task 3 & 4: Minh họa Fix State Update (setState) và Fix DatePicker context
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interactive Fixes Demo (setState & DatePicker):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Counter (with setState): $_counter'),
                      ElevatedButton(
                        onPressed: () {
                          // Fix 3: Cập nhật biến bên trong setState() để Flutter render lại
                          setState(() {
                            _counter++;
                          });
                        },
                        child: const Text('+1'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _pickedDate == null
                            ? 'No date picked'
                            : 'Date: ${_pickedDate!.day}/${_pickedDate!.month}/${_pickedDate!.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Builder(
                        // Fix 4: Dùng Builder để đảm bảo context hợp lệ nằm dưới Scaffold/Navigator
                        builder: (buttonContext) => ElevatedButton(
                          onPressed: () => _selectDate(buttonContext),
                          child: const Text('Pick Date'),
                        ),
                      ),
                    ],
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

// Hàm main để có thể chạy độc lập file này
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommonUiFixesDemo(),
    ),
  );
}
