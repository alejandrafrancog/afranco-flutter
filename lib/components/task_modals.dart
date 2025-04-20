import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/components/task_form.dart';
import 'package:afranco/data/task_repository.dart';

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
                title: updatedTask.title,
                description: updatedTask.description,
                type: updatedTask.type,
                fechaLimite: updatedTask.fechaLimite,
                pasos: updatedTask.pasos, 
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
}Future<void> showAddTaskModal(BuildContext context, Function(Task) onAddTask) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar Tarea'),
        content: SingleChildScrollView(
          child: TaskForm(
            onSave: (newTask) {
              final updatedTask = Task(
                id: newTask.id, 
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