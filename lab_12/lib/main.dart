import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const TasklyApp());
}

/// TasklyApp — Root widget using ChangeNotifierProvider.
///
/// Exercise 12.1: ChangeNotifierProvider wraps the app so that
/// Selector and Consumer can be used in child widgets to
/// selectively rebuild only when relevant state changes.
///
/// Exercise 12.4: All debug print() statements removed.
/// const constructors applied wherever possible.
class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(repository: TaskRepository()),
      child: MaterialApp(
        title: 'Taskly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}
