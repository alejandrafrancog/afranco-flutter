import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/helpers/common_widgets_helper.dart';
import 'package:afranco/components/task/task_image.dart';
import 'package:afranco/views/task_detail_screen.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';
import 'package:intl/intl.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int, bool) onToggle;
  final Function(Task, int) onEdit;
  final Function(Task, int) onDelete;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id ?? 'task_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) {
        context.read<TareasBloc>().add(TareasDeleteEvent(index: index));
        onDelete(task, index);
      },
      child: GestureDetector(
        onTap: () => _navigateToTaskDetail(context),
        child: Container(
          decoration: CommonWidgetsHelper.buildRoundedBorder(),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              TaskImage(randomIndex: index, height: 150),
              ListTile(
                leading: Checkbox(
                  value: task.completada,
                  onChanged: (bool? value) => onToggle(index, value ?? false),
                  activeColor: Colors.green,
                ),
                contentPadding: const EdgeInsets.all(16),
                title: CommonWidgetsHelper.buildBoldTitle(task.titulo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgetsHelper.buildSpacing(),
                    CommonWidgetsHelper.buildInfoLines(
                      line1: task.descripcion ?? 'Sin descripción',
                      line2: '',
                      line3: task.fechaLimite != null
                          ? DateFormat('dd/MM/yyyy').format(task.fechaLimite!)
                          : 'Sin fecha límite',
                      icon: task.tipo == 'urgente' ? Icons.warning : Icons.task,
                      iconColor: task.tipo == 'urgente' ? Colors.red : Colors.blue,
                    ),
                    CommonWidgetsHelper.buildSpacing(),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit(task, index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar "${task.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTaskDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          indice: index,
          onTaskUpdated: (updatedTask) {
            context.read<TareasBloc>().add(
              TareasUpdateEvent(tarea: updatedTask, index: index),
            );
          },
        ),
      ),
    );
  }
}
