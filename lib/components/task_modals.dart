import 'package:flutter/material.dart';
import '../domain/task.dart';

Future<void> showAddTaskModal(BuildContext context, Function(Task) onAddTask) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = 'normal';

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: Text('Agregar Tarea'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Título'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedType,
                    items: Task.taskTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newType) {
                      if (newType != null) {
                        setModalState(() {
                          selectedType = newType;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.length >= 3) {
                    final newTask = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      type: selectedType,
                      fechaLimite: DateTime.now().add(Duration(days: 7)), // Fecha límite predeterminada
                      pasos: [
                        'Paso 1: Planificar ${titleController.text}',
                        'Paso 2: Ejecutar ${titleController.text}',
                        'Paso 3: Revisar ${titleController.text}',
                      ], // Pasos simulados
                    );
                    onAddTask(newTask);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('El título debe tener al menos 3 caracteres')),
                    );
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showEditTaskModal(BuildContext context, Task task, Function(Task) onEditTask, Function() onDeleteTask) async {
  final TextEditingController titleController = TextEditingController(text: task.title);
  final TextEditingController descriptionController = TextEditingController(text: task.description);
  String selectedType = task.type ?? 'normal';

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: Text('Editar Tarea'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Título'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedType,
                    items: Task.taskTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newType) {
                      if (newType != null) {
                        setModalState(() {
                          selectedType = newType;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.length >= 3) {
                    final updatedTask = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      type: selectedType,
                      fechaLimite: task.fechaLimite, // Mantiene la fecha límite existente
                      pasos: task.pasos, // Mantiene los pasos existentes
                    );
                    onEditTask(updatedTask);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('El título debe tener al menos 3 caracteres')),
                    );
                  }
                },
                child: Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  onDeleteTask();
                  Navigator.of(context).pop();
                },
                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    },
  );
}

