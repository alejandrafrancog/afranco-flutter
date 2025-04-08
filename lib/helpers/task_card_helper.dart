import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';

Widget buildTaskCard(Task task) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
    child: ListTile(
      leading: Icon(
        task.type == 'urgente' ? Icons.warning : Icons.task,
        color: task.type == 'urgente' ? Colors.red : Colors.blue,
      ),
      title: Text(task.title),
      subtitle: Text('${AppConstants.TASK_TYPE_LABEL}: ${task.type}'),
    ),
  );
}