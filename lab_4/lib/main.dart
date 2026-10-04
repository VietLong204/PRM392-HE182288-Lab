import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_theme_demo.dart';
import 'common_ui_fixes_demo.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 – Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFFBFBFE),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const Lab4HomeScreen(),
    );
  }
}

class ExerciseOption {
  final String title;
  final Widget screen;

  const ExerciseOption({required this.title, required this.screen});
}

class Lab4HomeScreen extends StatelessWidget {
  const Lab4HomeScreen({super.key});

  final List<ExerciseOption> exercises = const [
    ExerciseOption(
      title: 'Exercise 1 – Core Widgets Demo',
      screen: CoreWidgetsDemo(),
    ),
    ExerciseOption(
      title: 'Exercise 2 – Input Controls Demo',
      screen: InputControlsDemo(),
    ),
    ExerciseOption(
      title: 'Exercise 3 – Layout Demo',
      screen: LayoutDemo(),
    ),
    ExerciseOption(
      title: 'Exercise 4 – App Structure & Theme',
      screen: AppStructureThemeDemo(),
    ),
    ExerciseOption(
      title: 'Exercise 5 – Common UI Fixes',
      screen: CommonUiFixesDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lab 4 – Flutter UI Fundament...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            elevation: 0,
            color: const Color(0xFFF3F3F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => exercise.screen),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 18.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        exercise.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 22,
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
