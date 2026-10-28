import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

/// TaskProvider manages the task state using ChangeNotifier.
///
/// Exercise 12.1: Using Provider + Selector to reduce unnecessary rebuilds.
/// Only widgets that use Selector<TaskProvider, List<Task>> will rebuild
/// when the task list changes, instead of rebuilding the entire screen.
class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;

  TaskProvider({required TaskRepository repository})
      : _repository = repository;

  /// Returns an unmodifiable copy of the current task list.
  List<Task> get tasks => _repository.tasks;

  /// Returns the underlying repository (for testing).
  TaskRepository get repository => _repository;

  /// Add a new task and notify listeners.
  void addTask(String title) {
    if (title.trim().isEmpty) return;

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    _repository.addTask(task);
    notifyListeners();
  }

  /// Toggle a task's completed status and notify listeners.
  void toggleTask(String id) {
    _repository.toggleTask(id);
    notifyListeners();
  }

  /// Delete a task and notify listeners.
  void deleteTask(String id) {
    _repository.deleteTask(id);
    notifyListeners();
  }

  /// Update a task's title and notify listeners.
  void updateTask(String id, String newTitle) {
    _repository.updateTask(id, newTitle);
    notifyListeners();
  }
}
