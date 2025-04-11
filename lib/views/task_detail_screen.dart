// views/task_detail_screen.dart
/*import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../components/task_image.dart';
import '../components/task_date_widget.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.indice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskImage(randomIndex: indice), // Widget reutilizable
            const SizedBox(height: 16),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              task.pasos.join('\n'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TaskDateWidget(task: task), // Widget reutilizable
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../components/task_image.dart';
import '../components/task_date_widget.dart';
import '../../api/service/task_service.dart'; // Asegúrate de importar tu repositorio

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.indice,
  }) : super(key: key);

  void _navigateToAdjacentTask(BuildContext context, int offset) {
    final tasks = TaskService().getAllTasks(); // Obtén todas las tareas
    final newIndex = indice + offset;
    
    if (newIndex >= 0 && newIndex < tasks.length) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => TaskDetailScreen(
            task: tasks[newIndex],
            indice: newIndex,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideOffset = Offset(offset.sign.toDouble(), 0.0);
            return SlideTransition(
              position: Tween<Offset>(
                begin: slideOffset,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _navigateToAdjacentTask(context, -1); // Deslizamiento hacia la derecha
        } else if (details.primaryVelocity! < 0) {
          _navigateToAdjacentTask(context, 1); // Deslizamiento hacia la izquierda
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(task.title)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskImage(randomIndex: indice),
              const SizedBox(height: 16),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                task.pasos.join('\n'),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TaskDateWidget(task: task),
            ],
          ),
        ),
      ),
    );
  }
}