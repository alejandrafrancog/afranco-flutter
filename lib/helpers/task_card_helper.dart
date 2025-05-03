import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/views/task_detail_screen.dart';  
Widget buildTaskCard(Task task) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 8,
    child: ListTile(
      leading: Icon(
        task.type == 'urgente' ? Icons.warning : Icons.task,
        color: task.type == 'urgente' ? Colors.red : Colors.blue,
      ),
      title: Text(task.title),
      subtitle: Text('${AppConstants.taskTypeLabel}: ${task.type}'),
    ),
  );
}


Widget construirTarjetaDeportiva(BuildContext context, Task task, int indice, VoidCallback onEdit, VoidCallback onDelete,  Future<void> Function() onNeedMoreTasks,
) {
  return Dismissible(
    key: UniqueKey(), // Identificador único para el widget
    direction: DismissDirection.endToStart, // Permite deslizar solo de derecha a izquierda
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    onDismissed: (direction) {
      onDelete(); // Llama al callback para eliminar la tarea
    },
    child: GestureDetector(
          onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(
              task: task,
              indice: indice,
              onNeedMoreTasks: onNeedMoreTasks, // <<< Pasa el callback aquí
            ),
          ),
        );
      },

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen aleatoria
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                'https://picsum.photos/200/300?random=$indice',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Pasos
                  Text(
                    task.pasos.take(3).join('\n'),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  // Fecha límite
                  Text(
                    'Fecha límite: ${task.fechaLimite.day.toString().padLeft(2, '0')}/'
                    '${task.fechaLimite.month.toString().padLeft(2, '0')}/'
                    '${task.fechaLimite.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       Icon(
                          task.type == 'urgente' ? Icons.warning : Icons.task,
                          color: task.type == 'urgente' 
                          ? Colors.red.withAlpha(128) 
                          : Colors.blue.withAlpha(128),
                          size:20,
        ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit, // Llama al callback para editar
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onDelete, // Llama al callback para eliminar
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}