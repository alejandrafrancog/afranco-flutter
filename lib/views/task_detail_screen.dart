
import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../api/service/task_service.dart';
import '../components/task_image.dart';
import '../components/task_date_widget.dart';
import '../components/task_modals.dart';
import '../helpers/common_widgets_helper.dart';
class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.indice,
  }) : super(key: key);

  void _navigateToAdjacentTask(BuildContext context, int offset) {
    final tasks = TaskService().getAllTasks();
    final newIndex = indice + offset;
    
    if (newIndex >= 0 && newIndex < tasks.length) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => TaskDetailScreen(
            task: tasks[newIndex],
            indice: newIndex,
          ),
          transitionsBuilder: (context, animation, _, child) {
            final slideOffset = Offset(offset.sign.toDouble(), 0);
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
  void _handleSwipe(BuildContext context, DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      // Deslizamiento hacia la derecha
      _navigateToAdjacentTask(context, -1);
    } else if (details.primaryVelocity! < 0) {
      // Deslizamiento hacia la izquierda
      _navigateToAdjacentTask(context, 1);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(task.title), // Título numerado
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(context),
        ),
      ],
    ),
    body: GestureDetector(
      onHorizontalDragEnd: (details) => _handleSwipe(context, details),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: CommonWidgetsHelper.buildRoundedBorder(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskImage(randomIndex: indice, height: 250),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y tag de urgente
                    Row(
                      children: [
                        Expanded(
                          child: CommonWidgetsHelper.buildBoldTitle(task.title),
                        ),
                        _buildTaskTypeTag(context),
                      ],
                    ),
                    CommonWidgetsHelper.buildSpacing(),

                    // Pasos con formato de lista
                    CommonWidgetsHelper.buildInfoLines(
                      line1: 'Pasos:',
                      line2: task.pasos.join('\n'),
                    ),
                    CommonWidgetsHelper.buildSpacing(),

                    // Fecha límite
                    CommonWidgetsHelper.buildBoldFooter(
                      'Fecha límite: ${DateTime(2025,04,10,12,00,00)}'
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildTaskTypeTag(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: task.type == 'urgente' 
          ? Colors.redAccent 
          : Colors.blueAccent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      task.type.toString().toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

  Widget _buildDetailSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          task.pasos.join('\n\n'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        TaskDateWidget(task: task),
        const SizedBox(height: 20),
        _buildTaskTypeChip(context),
      ],
    );
  }

  Widget _buildTaskTypeChip(BuildContext context) {
    return Chip(
      label: Text(
        task.type.toString().toUpperCase(),
        style: TextStyle(
          color: task.type == 'urgente' ? Colors.red : Colors.green,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarea'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}