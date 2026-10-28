import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/providers/task_provider.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('TaskProvider Tests', () {
    late TaskProvider provider;
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
      provider = TaskProvider(repository: repository);
    });

    test('should start with empty task list', () {
      expect(provider.tasks, isEmpty);
    });

    test('should add a task and notify listeners', () {
      bool notified = false;
      provider.addListener(() => notified = true);

      provider.addTask('New Task');
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.title, 'New Task');
      expect(notified, true);
    });

    test('should not add a task with empty title', () {
      bool notified = false;
      provider.addListener(() => notified = true);

      provider.addTask('');
      expect(provider.tasks, isEmpty);
      expect(notified, false);

      provider.addTask('   ');
      expect(provider.tasks, isEmpty);
      expect(notified, false);
    });

    test('should toggle a task and notify listeners', () {
      provider.addTask('Task 1');
      final taskId = provider.tasks.first.id;

      bool notified = false;
      provider.addListener(() => notified = true);

      provider.toggleTask(taskId);
      expect(provider.tasks.first.completed, true);
      expect(notified, true);
    });

    test('should delete a task and notify listeners', () {
      provider.addTask('Task 1');
      final taskId = provider.tasks.first.id;

      bool notified = false;
      provider.addListener(() => notified = true);

      provider.deleteTask(taskId);
      expect(provider.tasks, isEmpty);
      expect(notified, true);
    });

    test('should update a task title and notify listeners', () {
      provider.addTask('Old Title');
      final taskId = provider.tasks.first.id;

      bool notified = false;
      provider.addListener(() => notified = true);

      provider.updateTask(taskId, 'New Title');
      expect(provider.tasks.first.title, 'New Title');
      expect(notified, true);
    });

    test('should expose the repository', () {
      expect(provider.repository, repository);
    });
  });
}
