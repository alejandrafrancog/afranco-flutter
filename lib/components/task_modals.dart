import 'package:flutter/material.dart';
import '../domain/task.dart';
import 'task_form.dart';
import 'task_form.dart';
import '../data/task_repository.dart';

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
              // Regenerar pasos usando generateSteps
              final newTask = Task(
                title: updatedTask.title,
                description: updatedTask.description,
                type: updatedTask.type,
                fechaLimite: updatedTask.fechaLimite,
                pasos: TaskRepository.generateSteps(updatedTask.title, updatedTask.fechaLimite),
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
Future<void> showAddTaskModal(BuildContext context, Function(Task) onAddTask) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar Tarea'),
        content: SingleChildScrollView(
          child: TaskForm(
            onSave: (newTask) {
              // Generar pasos usando generateSteps
              final updatedTask = Task(
                title: newTask.title,
                description: newTask.description,
                type: newTask.type,
                fechaLimite: newTask.fechaLimite,
                pasos: TaskRepository.generateSteps(newTask.title, newTask.fechaLimite),
              );
              onAddTask(updatedTask);
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );
}
