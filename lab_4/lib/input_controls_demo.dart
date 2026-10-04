import 'package:flutter/material.dart';

/// Exercise 2: Input Widgets (Slider, Switch, RadioListTile, DatePicker)
/// Màn hình tương tác người dùng với các điều khiển nhập liệu.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}
class _InputControlsDemoState extends State<InputControlsDemo> {
  // Trạng thái giá trị của Slider
  double _sliderValue = 50.0;
  // Trạng thái của Switch
  bool _isMovieActive = false;
  // Trạng thái thể loại đã chọn (RadioListTile)
  String? _selectedGenre;
  // Trạng thái ngày được chọn từ DatePicker
  DateTime? _selectedDate;
  // Hàm mở DatePicker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Controls'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Rating (Slider)
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text(
              'Current value: ${_sliderValue.toInt()}',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // 2. Active (Switch)
            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Is movie active?',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Switch(
                  value: _isMovieActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isMovieActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Genre (RadioListTile)
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Action'),
              value: 'Action',
              // ignore: deprecated_member_use
              groupValue: _selectedGenre,
              // ignore: deprecated_member_use
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Comedy'),
              value: 'Comedy',
              // ignore: deprecated_member_use
              groupValue: _selectedGenre,
              // ignore: deprecated_member_use
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            Text(
              'Selected genre: ${_selectedGenre ?? "None"}',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // 4. DatePicker Button & Selected Date
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.blueAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onPressed: () => _pickDate(context),
                child: Text(
                  _selectedDate == null
                      ? 'Open Date Picker'
                      : 'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
      home: InputControlsDemo(),
    ),
  );
}
