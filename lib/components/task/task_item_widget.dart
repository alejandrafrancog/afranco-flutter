import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task/widgets/task_header.dart';
import 'package:afranco/components/task/widgets/task_content.dart';
import 'package:afranco/components/task/widgets/task_dismissible.dart';
import 'package:afranco/views/task_detail_screen.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int, bool) onToggle;
  final Function(Task, int) onEdit;
  final Function(Task, int) onDelete;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TaskDismissible(
      task: task,
      index: index,
      onDelete: onDelete,
      child: GestureDetector(
        onTap: () => _navigateToTaskDetail(context),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: _buildCardDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                TaskHeader(task: task, index: index),
                TaskContent(
                  task: task,
                  index: index,
                  onToggle: onToggle,
                  onEdit: onEdit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 2,
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Colors.grey.shade50,
        ],
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          indice: index,
          onTaskUpdated: (updatedTask) {
            context.read<TareasBloc>().add(
              TareasUpdateEvent(tarea: updatedTask, index: index),
            );
          },
        ),
      ),
    );
  }
}
