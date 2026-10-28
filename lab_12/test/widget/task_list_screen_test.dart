import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/task_provider.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    late TaskProvider provider;

    Widget createApp() {
      return ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(
          home: TaskListScreen(),
        ),
      );
    }

    setUp(() {
      provider = TaskProvider(repository: TaskRepository());
    });

    testWidgets('should show empty state message when no tasks',
        (tester) async {
      await tester.pumpWidget(createApp());
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('should show input field and add button', (tester) async {
      await tester.pumpWidget(createApp());
      expect(find.byKey(const Key('taskInputField')), findsOneWidget);
      expect(find.byKey(const Key('addTaskButton')), findsOneWidget);
    });

    testWidgets('should add a task when button is pressed', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'New Task');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('New Task'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('should toggle task when checkbox is tapped', (tester) async {
      await tester.pumpWidget(createApp());

      // Add a task
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Toggle Me');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Toggle it
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(provider.tasks.first.completed, true);
    });

    testWidgets('should delete task when delete icon is tapped',
        (tester) async {
      await tester.pumpWidget(createApp());

      // Add a task
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Delete Me');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('Delete Me'), findsOneWidget);

      // Delete it
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Delete Me'), findsNothing);
      expect(provider.tasks, isEmpty);
    });

    testWidgets('should not add empty task', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(provider.tasks, isEmpty);
    });

    testWidgets('should clear input after adding task', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Task');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      final textField = tester.widget<TextField>(
          find.byKey(const Key('taskInputField')));
      expect(textField.controller?.text, '');
    });

    testWidgets('should display app title', (tester) async {
      await tester.pumpWidget(createApp());
      expect(find.text('Taskly'), findsOneWidget);
    });
  });
}
