import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task/widgets/task_title_row.dart';
import 'package:afranco/components/task/widgets/task_deadline.dart';

class TaskContent extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int, bool) onToggle;
  final Function(Task, int) onEdit;

  const TaskContent({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskTitleRow(
            task: task,
            index: index,
            onToggle: onToggle,
            onEdit: onEdit,
          ),
          if (task.fechaLimite != null)
            TaskDeadline(fechaLimite: task.fechaLimite!),
        ],
      ),
    );
  }
}