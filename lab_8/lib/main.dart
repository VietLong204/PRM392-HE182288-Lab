import 'package:flutter/material.dart';
import 'screens/post_list_screen.dart';


void main() {
  runApp(const Lab8App());
}

class Lab8App extends StatelessWidget {
  const Lab8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 – API Networking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        fontFamily: 'sans-serif',
      ),
      home: const PostListScreen(),
    );
  }
}
