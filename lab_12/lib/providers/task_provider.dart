import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;

  TaskProvider({required TaskRepository repository})
      : _repository = repository;

  List<Task> get tasks => List.from(_repository.tasks);

  TaskRepository get repository => _repository;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    _repository.addTask(task);
    notifyListeners();
  }

  void toggleTask(String id) {
    _repository.toggleTask(id);
    notifyListeners();
  }

  void deleteTask(String id) {
    _repository.deleteTask(id);
    notifyListeners();
  }

  void updateTask(String id, String newTitle) {
    _repository.updateTask(id, newTitle);
    notifyListeners();
  }
}
