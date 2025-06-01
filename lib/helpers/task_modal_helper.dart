import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task/task_form.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';

class TaskModalHelper {
  static void showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nueva Tarea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TaskForm(
              onSave: (newTask) {
                if (newTask.titulo.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El título de la tarea es obligatorio'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                context.read<TareasBloc>().add(TareasAddEvent(tarea: newTask));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showEditTaskModal(BuildContext context, Task task, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Tarea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TaskForm(
              task: task,
              onSave: (updatedTask) {
                context.read<TareasBloc>().add(
                  TareasUpdateEvent(tarea: updatedTask, index: index),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
