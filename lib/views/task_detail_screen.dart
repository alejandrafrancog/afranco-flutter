import 'package:flutter/material.dart';
import '../domain/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;

  const TaskDetailScreen({Key? key, required this.task, required this.indice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),      // Imagen aleatoria
              child: Image.network(
                'https://picsum.photos/200/300?random=$indice',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),


            const SizedBox(height: 16),
            // Título
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Pasos
            Text(
              task.pasos.join('\n'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Fecha límite
            Text(
              'Fecha límite: ${task.fechaLimite.day.toString().padLeft(2, '0')}/'
              '${task.fechaLimite.month.toString().padLeft(2, '0')}/'
              '${task.fechaLimite.year}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}