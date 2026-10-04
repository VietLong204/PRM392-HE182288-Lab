import 'package:flutter/material.dart';

/// Exercise 4: App Structure with Scaffold, AppBar, FAB & Theme
/// Màn hình hoàn chỉnh có cấu trúc Scaffold, nút FAB và chuyển đổi giao diện Sáng / Tối (Theme Mode).
class AppStructureThemeDemo extends StatefulWidget {
  const AppStructureThemeDemo({super.key});

  @override
  State<AppStructureThemeDemo> createState() => _AppStructureThemeDemoState();
}

class _AppStructureThemeDemoState extends State<AppStructureThemeDemo> {
  // Trạng thái bật/tắt Dark Mode
  bool _isDarkMode = false;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // Tùy chỉnh ThemeData cho Light & Dark theme
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (context) {
          return Scaffold(
            // 1. AppBar với tiêu đề và nút gạt Dark Mode
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.maybePop(context),
              ),
              title: const Text(
                'Exercise 4 – App Structure & Theme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Dark',
                      style: TextStyle(fontSize: 13),
                    ),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (bool value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),

            // 2. Body
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'This is a simple screen with theme toggle.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_counter > 0)
                      Text(
                        'FAB clicked: $_counter time${_counter > 1 ? "s" : ""}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 3. FloatingActionButton
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('FloatingActionButton clicked! (Count: $_counter)'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

// Hàm main để có thể chạy độc lập file này
void main() {
  runApp(const AppStructureThemeDemo());
}
