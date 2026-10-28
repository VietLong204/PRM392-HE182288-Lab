import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/task_provider.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('Task Integration Tests', () {
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

    testWidgets('full workflow: add → toggle → navigate detail → delete',
        (tester) async {
      await tester.pumpWidget(createApp());

      // Step 1: Add a task
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Integration Task');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('Integration Task'), findsOneWidget);
      expect(provider.tasks.length, 1);

      // Step 2: Toggle the task
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(provider.tasks.first.completed, true);

      // Step 3: Navigate to detail screen
      await tester.tap(find.text('Integration Task'));
      await tester.pumpAndSettle();

      expect(find.text('Task Detail'), findsOneWidget);
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);

      // Step 4: Edit and save
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Updated Task');
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle();

      expect(provider.tasks.first.title, 'Updated Task');

      // Step 5: Back on list screen — delete the task
      expect(find.text('Updated Task'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(provider.tasks, isEmpty);
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('add multiple tasks and verify list order', (tester) async {
      await tester.pumpWidget(createApp());

      // Add 3 tasks
      for (final title in ['Task A', 'Task B', 'Task C']) {
        await tester.enterText(
            find.byKey(const Key('taskInputField')), title);
        await tester.tap(find.byKey(const Key('addTaskButton')));
        await tester.pump();
      }

      expect(provider.tasks.length, 3);
      expect(find.text('Task A'), findsOneWidget);
      expect(find.text('Task B'), findsOneWidget);
      expect(find.text('Task C'), findsOneWidget);
    });

    testWidgets('toggle multiple tasks independently', (tester) async {
      await tester.pumpWidget(createApp());

      // Add 2 tasks
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'First');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Second');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Toggle only the first task
      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.first);
      await tester.pump();

      expect(provider.tasks[0].completed, true);
      expect(provider.tasks[1].completed, false);
    });
  });
}
