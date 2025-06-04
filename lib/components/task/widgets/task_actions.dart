import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';

class TaskActions extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int, bool) onToggle;
  final Function(Task, int) onEdit;

  const TaskActions({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.edit_rounded,
              color: Colors.blue.shade700,
            ),
            onPressed: () => onEdit(task, index),
            tooltip: 'Editar tarea',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: task.completada 
                  ? Colors.green 
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: task.completada,
              onChanged: (bool? value) => onToggle(index, value ?? false),
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
