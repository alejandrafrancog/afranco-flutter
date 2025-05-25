import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/constants/constants.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      ),
      child: ListTile(
        leading: Icon(
          task.tipo == 'urgente' ? Icons.warning : Icons.task,
          color: task.tipo == 'urgente' ? Colors.red : Colors.blue,
        ),
        title: Text(task.titulo),
        subtitle: Text('${AppConstants.taskTypeLabel}: ${task.tipo}'),
      ),
    );
  }
}