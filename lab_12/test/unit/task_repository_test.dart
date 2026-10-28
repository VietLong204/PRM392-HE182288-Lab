import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('TaskRepository Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('should start with an empty task list', () {
      expect(repository.tasks, isEmpty);
    });

    test('should add a task', () {
      repository.addTask(Task(id: '1', title: 'Task 1'));
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Task 1');
    });

    test('should delete a task by id', () {
      repository.addTask(Task(id: '1', title: 'Task 1'));
      repository.addTask(Task(id: '2', title: 'Task 2'));
      repository.deleteTask('1');
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, '2');
    });

    test('should update a task title', () {
      repository.addTask(Task(id: '1', title: 'Old Title'));
      repository.updateTask('1', 'New Title');
      expect(repository.tasks.first.title, 'New Title');
    });

    test('should toggle a task completed status', () {
      repository.addTask(Task(id: '1', title: 'Task'));
      expect(repository.tasks.first.completed, false);
      repository.toggleTask('1');
      expect(repository.tasks.first.completed, true);
      repository.toggleTask('1');
      expect(repository.tasks.first.completed, false);
    });

    test('should clear all tasks', () {
      repository.addTask(Task(id: '1', title: 'Task 1'));
      repository.addTask(Task(id: '2', title: 'Task 2'));
      repository.clear();
      expect(repository.tasks, isEmpty);
    });

    test('should return unmodifiable list', () {
      repository.addTask(Task(id: '1', title: 'Task'));
      expect(
        () => repository.tasks.add(Task(id: '2', title: 'Fail')),
        throwsUnsupportedError,
      );
    });
  });
}
