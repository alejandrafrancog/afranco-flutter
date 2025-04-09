// views/task_detail_screen.dart
import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../components/task_image.dart';
import '../components/task_date_widget.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.indice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskImage(randomIndex: indice), // Widget reutilizable
            const SizedBox(height: 16),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              task.pasos.join('\n'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TaskDateWidget(task: task), // Widget reutilizable
          ],
        ),
      ),
    );
  }
}
