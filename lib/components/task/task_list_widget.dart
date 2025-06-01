import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/components/task/task_item_widget.dart';

class TaskListWidget extends StatelessWidget {
  final TareasState state;
  final ScrollController scrollController;
  final Function(int, bool) onTaskToggle;
  final Function(Task, int) onTaskEdit;
  final Function(Task, int) onTaskDelete;

  const TaskListWidget({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onTaskToggle,
    required this.onTaskEdit,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Mostrar indicador de carga
    if (state.status == TareasStatus.loading && state.tareas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando tareas...'),
          ],
        ),
      );
    }

    // Mostrar mensaje de lista vacía
    if (state.tareas.isEmpty && state.status != TareasStatus.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              AppConstantes.emptyList,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16),
          ],
        ),
      );
    }

    // Mostrar lista de tareas
    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          itemCount: state.tareas.length,
          itemBuilder: (context, index) {
            final task = state.tareas[index];
            return TaskItemWidget(
              task: task,
              index: index,
              onToggle: onTaskToggle,
              onEdit: onTaskEdit,
              onDelete: onTaskDelete,
            );
          },
        ),
        if (state.status == TareasStatus.loading && state.tareas.isNotEmpty)
          Container(
            color: Colors.black12,
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Procesando...'),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
