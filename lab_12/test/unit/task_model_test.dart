import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('should create a task with default completed = false', () {
      const task = Task(id: '1', title: 'Test Task');
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.completed, false);
    });

    test('should create a task with completed = true', () {
      const task = Task(id: '2', title: 'Done Task', completed: true);
      expect(task.completed, true);
    });

    test('toggle() should return a new Task with inverted completed', () {
      const task = Task(id: '1', title: 'Test');
      final toggled = task.toggle();
      expect(toggled.completed, true);
      expect(task.completed, false); // original unchanged (immutable)
    });

    test('copyWith() should create a new Task with updated fields', () {
      const task = Task(id: '1', title: 'Original');
      final updated = task.copyWith(title: 'Updated');
      expect(updated.title, 'Updated');
      expect(updated.id, '1');
      expect(task.title, 'Original'); // original unchanged
    });

    test('equality should work correctly', () {
      const task1 = Task(id: '1', title: 'A');
      const task2 = Task(id: '1', title: 'A');
      const task3 = Task(id: '1', title: 'B');
      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('hashCode should be consistent with equality', () {
      const task1 = Task(id: '1', title: 'A');
      const task2 = Task(id: '1', title: 'A');
      expect(task1.hashCode, task2.hashCode);
    });

    test('toString should return a readable representation', () {
      const task = Task(id: '1', title: 'Test', completed: false);
      expect(task.toString(), 'Task(id: 1, title: Test, completed: false)');
    });
  });
}
