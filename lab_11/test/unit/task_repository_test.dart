import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('TaskRepository', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask adds a task', () {
      repository.addTask(Task(id: '1', title: 'Task 1'));
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Task 1');
    });

    test('deleteTask removes task by id', () {
      repository.addTask(Task(id: '1', title: 'Task 1'));
      repository.addTask(Task(id: '2', title: 'Task 2'));

      repository.deleteTask('1');

      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, '2');
    });

    test('updateTask changes title', () {
      repository.addTask(Task(id: '1', title: 'Old'));

      repository.updateTask('1', 'New');

      expect(repository.tasks.first.title, 'New');
    });
  });
}
