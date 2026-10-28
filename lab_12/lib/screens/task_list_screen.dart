import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

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
    // Pre-cache logo để tối ưu load ảnh (Exercise 12.2)
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

  void _openDetail(Task task) {
    Navigator.push(
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
            Image.asset(
              'assets/images/taskly_logo.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text('Taskly'),
          ],
        ),
      ),
      body: Column(
        children: [
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
          // Dùng Selector để chỉ rebuild ListView khi danh sách tasks thay đổi (Exercise 12.1)
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (_, provider) => provider.tasks,
              builder: (context, tasks, child) {
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks yet. Add one!'),
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
