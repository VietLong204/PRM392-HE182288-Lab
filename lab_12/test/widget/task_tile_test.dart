import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/widgets/task_tile.dart';

void main() {
  group('TaskTile Widget Tests', () {
    testWidgets('should display task title', (tester) async {
      final task = Task(id: '1', title: 'Test Task');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('should show unchecked checkbox for incomplete task',
        (tester) async {
      final task = Task(id: '1', title: 'Task', completed: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });

    testWidgets('should show checked checkbox for completed task',
        (tester) async {
      final task = Task(id: '1', title: 'Done', completed: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('should show strikethrough for completed task',
        (tester) async {
      final task = Task(id: '1', title: 'Done', completed: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Done'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('should call onToggle when checkbox is tapped',
        (tester) async {
      bool toggled = false;
      final task = Task(id: '1', title: 'Task');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () => toggled = true,
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      expect(toggled, true);
    });

    testWidgets('should call onDelete when delete icon is tapped',
        (tester) async {
      bool deleted = false;
      final task = Task(id: '1', title: 'Task');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () {},
              onDelete: () => deleted = true,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      expect(deleted, true);
    });

    testWidgets('should call onTap when tile is tapped', (tester) async {
      bool tapped = false;
      final task = Task(id: '1', title: 'Task');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: task,
              onToggle: () {},
              onDelete: () {},
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Task'));
      expect(tapped, true);
    });

    testWidgets('should have a ValueKey with task id', (tester) async {
      final task = Task(id: 'abc123', title: 'Task');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              key: ValueKey(task.id),
              task: task,
              onToggle: () {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('abc123')), findsOneWidget);
    });
  });
}
