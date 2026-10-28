import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    Widget buildApp() {
      return MaterialApp(
        home: TaskListScreen(repository: repository),
      );
    }

    testWidgets('shows empty state message', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('adds a task', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.enterText(find.byType(TextField), 'Buy Groceries');
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Buy Groceries'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('adds multiple tasks', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.enterText(find.byType(TextField), 'Task A');
      await tester.tap(find.text('Add'));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Task B');
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Task A'), findsOneWidget);
      expect(find.text('Task B'), findsOneWidget);
    });
  });
}
