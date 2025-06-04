import 'package:afranco/components/task/task_modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';

class TaskDismissible extends StatelessWidget {
  final Task task;
  final int index;
  final Function(Task, int) onDelete;
  final Widget child;

  const TaskDismissible({
    super.key,
    required this.task,
    required this.index,
    required this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id ?? 'task_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => showDeleteConfirmation(context,task),
      onDismissed: (direction) {
        context.read<TareasBloc>().add(TareasDeleteEvent(index: index));
        onDelete(task, index);
      },
      child: child,
    );
  }

}