import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';

class TaskDateWidget extends StatelessWidget {
  final Task task;

  const TaskDateWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Fecha límite: ${_formatDate(task.fechaLimite ?? DateTime.now())}',
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
