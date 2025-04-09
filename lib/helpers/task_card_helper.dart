import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';

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
      subtitle: Text('${AppConstants.TASK_TYPE_LABEL}: ${task.type}'),
    ),
  );
}

Widget construirTarjetaDeportiva(Task task, int indice) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen aleatoria
        ClipRRect(
            borderRadius: BorderRadius.vertical(top:Radius.circular(12.0)),
                    child:Image.network(
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
              // Pasos (hasta 3 líneas)
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
            ],
          ),
        ),
      ],
    ),
  );
}