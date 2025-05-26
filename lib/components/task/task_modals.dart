import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart' show TareasAddEvent;
import 'package:afranco/core/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task/task_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_it/watch_it.dart';

Future<void> showEditTaskModal(
  BuildContext context,
  Task task, 
  Function(Task) onEditTask, 
  Function() onDeleteTask,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar Tarea'),
        content: SingleChildScrollView(
          child: TaskForm(
            task: task,
            onSave: (updatedTask) {
              final newTask = Task(
                id: task.id,
                usuario: task.usuario, // Mantener el usuario original
                titulo: updatedTask.titulo,
                descripcion: updatedTask.descripcion,
                tipo: updatedTask.tipo,
                fecha: task.fecha, // Mantener la fecha original de creación
                fechaLimite: updatedTask.fechaLimite,
              );
              onEditTask(newTask);
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onDeleteTask();
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
// Remover el guión bajo para hacerlo público
void showAddTaskModal(BuildContext context) {
  final secureStorage = di<SecureStorageService>();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
          FutureBuilder<String?>(
            future: secureStorage.getUserEmail(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error obteniendo usuario');
              }
              
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              
              return TaskForm(
                onSave: (newTask) {
                  // Asegurar que la tarea tenga el usuario correcto
                  final taskWithUser = newTask.copyWith(
                    usuario: snapshot.data,
                  );
                  
                  context.read<TareasBloc>().add(
                    TareasAddEvent(tarea: taskWithUser),
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}