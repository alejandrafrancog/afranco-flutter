import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task/widgets/task_actions.dart';

class TaskTitleRow extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int, bool) onToggle;
  final Function(Task, int) onEdit;

  const TaskTitleRow({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.titulo,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: task.completada 
                  ? Colors.grey.shade600
                  : Colors.black87,
              decoration: task.completada 
                  ? TextDecoration.lineThrough 
                  : null,
            ),
          ),
        ),
        TaskActions(
          task: task,
          index: index,
          onToggle: onToggle,
          onEdit: onEdit,
        ),
      ],
    );
  }
}