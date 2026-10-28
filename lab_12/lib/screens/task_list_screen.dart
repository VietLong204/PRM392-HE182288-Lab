import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

/// TaskListScreen — Optimized with Provider Selector.
///
/// Exercise 12.1 Optimizations Applied:
/// 1. Uses Selector<TaskProvider, List<Task>> instead of Consumer/watch
///    to only rebuild the list portion when tasks change.
/// 2. TaskTile extracted into a separate widget to reduce rebuild scope.
/// 3. const constructors used on all static widgets.
/// 4. ValueKey(task.id) assigned to each TaskTile for efficient diffing.
///
/// Exercise 12.2 Optimization:
/// - precacheImage() called in didChangeDependencies for app logo.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Exercise 12.2: Pre-cache the app logo image for smoother rendering
    precacheImage(const AssetImage('assets/images/taskly_logo.png'), context);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isNotEmpty) {
      context.read<TaskProvider>().addTask(title);
      _taskController.clear();
    }
  }

  Future<void> _openDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Exercise 12.2: Optimized image (resized to 128x128)
            Image.asset(
              'assets/images/taskly_logo.png',
              width: 32,
              height: 32,
              // Use cacheWidth/cacheHeight to decode at display size,
              // saving memory and improving performance
              cacheWidth: 64,
              cacheHeight: 64,
            ),
            const SizedBox(width: 8),
            const Text('Taskly'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Input section — static, does not depend on task list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new task...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('addTaskButton'),
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Exercise 12.1: Use Selector to only rebuild the list
          // when the task list actually changes, not on every provider update.
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (_, provider) => provider.tasks,
              builder: (context, tasks, child) {
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet. Add one!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      key: ValueKey(task.id),
                      task: task,
                      onToggle: () {
                        context.read<TaskProvider>().toggleTask(task.id);
                      },
                      onDelete: () {
                        context.read<TaskProvider>().deleteTask(task.id);
                      },
                      onTap: () => _openDetail(task),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
