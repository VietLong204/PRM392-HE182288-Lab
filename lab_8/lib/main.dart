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
      title: 'Lab 8 - REST API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const PostListScreen(),
    );
  }
}
