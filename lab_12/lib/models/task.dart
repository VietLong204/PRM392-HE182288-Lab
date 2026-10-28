/// Task model representing a single task in the Taskly app.
/// Immutable design to support efficient rebuild detection with Provider/Selector.
class Task {
  final String id;
  final String title;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  /// Creates a copy of this Task with the given fields replaced.
  Task copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  /// Toggle the completed status and return a new Task.
  Task toggle() {
    return copyWith(completed: !completed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode;

  @override
  String toString() => 'Task(id: $id, title: $title, completed: $completed)';
}
