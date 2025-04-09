// components/task_date_widget.dart
import 'package:flutter/material.dart';
import '../domain/task.dart';

class TaskDateWidget extends StatelessWidget {
  final Task task;

  const TaskDateWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Fecha límite: ${_formatDate(task.fechaLimite)}',
      style: const TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}
