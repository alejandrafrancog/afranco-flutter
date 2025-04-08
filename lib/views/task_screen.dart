import 'package:flutter/material.dart';
import '../constants.dart';
import '../domain/task.dart';
import '../data/task_repository.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskRepository _repository = TaskRepository();
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _repository.getAllTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = _repository.getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_APPBAR),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return Center(child: Text(EMPTY_LIST));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) async {
                    await _repository.toggleTaskCompletion(task.id);
                    _refreshTasks();
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _repository.deleteTask(task.id);
                    _refreshTasks();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Tarea ${DateTime.now().second}',
          );
          await _repository.addTask(newTask);
          _refreshTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}