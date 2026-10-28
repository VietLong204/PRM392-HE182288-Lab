import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('should create a task with default completed = false', () {
      final task = Task(id: '1', title: 'Test Task');
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.completed, false);
    });

    test('should create a task with completed = true', () {
      final task = Task(id: '2', title: 'Done Task', completed: true);
      expect(task.completed, true);
    });

    test('toggle() should switch completed status', () {
      final task = Task(id: '1', title: 'Test');
      expect(task.completed, false);
      task.toggle();
      expect(task.completed, true);
      task.toggle();
      expect(task.completed, false);
    });
  });
}
