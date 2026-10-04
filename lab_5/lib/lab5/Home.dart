import 'package:flutter/material.dart';
import 'Ex1.dart';
import 'Ex2.dart';
import 'Ex3.dart';
import 'Ex4.dart';
import 'Ex5.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<_ExerciseOption> _exercises = const [
    _ExerciseOption(
      title: 'Exercise 1 – Data Model & Sample Data',
      subtitle: 'Define Movie & Trailer models with static sample data',
      screen: Exercise1(),
    ),
    _ExerciseOption(
      title: 'Exercise 2 – Home Screen & Movie List',
      subtitle: 'ListView.builder with search filter & MovieCard',
      screen: Exercise2(),
    ),
    _ExerciseOption(
      title: 'Exercise 3 – Banner & Chips',
      subtitle: 'Hero banner with gradient & Genres chips',
      screen: Exercise3(),
    ),
    _ExerciseOption(
      title: 'Exercise 4 – Overview, Actions & Trailers',
      subtitle: 'Movie overview, action buttons & trailers list',
      screen: Exercise4(),
    ),
    _ExerciseOption(
      title: 'Exercise 5 – Complete Movie Detail App',
      subtitle: 'Full 2-screen navigation, rating dialog & favorite toggle',
      screen: Exercise5(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Lab 5 – Movie Detail App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        itemCount: _exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _exercises[index];
          return Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.screen),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExerciseOption {
  final String title;
  final String subtitle;
  final Widget screen;

  const _ExerciseOption({
    required this.title,
    required this.subtitle,
    required this.screen,
  });
}
