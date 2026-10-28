import 'package:flutter/material.dart';
import '../models/task.dart';

/// TaskTile — Extracted widget for a single task item.
///
/// Exercise 12.1: Extracting TaskTile into a separate widget reduces
/// unnecessary rebuilds. Each TaskTile is a self-contained widget with
/// its own build method, so Flutter can skip rebuilding tiles that
/// haven't changed.
///
/// Key optimizations applied:
/// - Uses ValueKey(task.id) for efficient list diffing
/// - Uses const constructors where possible
/// - Separated from the parent list to minimize rebuild scope
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          color: task.completed ? Colors.grey : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
