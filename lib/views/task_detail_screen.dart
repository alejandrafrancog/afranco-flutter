import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/components/task/task_image.dart';
import 'package:afranco/components/task/task_form.dart';
import 'package:afranco/helpers/common_widgets_helper.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;
  final Function(Task)? onTaskUpdated; // Callback para actualizar la tarea

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.indice,
    this.onTaskUpdated,
  });

  void _navigateToAdjacentTask(BuildContext context, int offset) {
    final tareasBloc = context.read<TareasBloc>();
    final currentState = tareasBloc.state;
    
    if (currentState.status != TareasStatus.loaded) return;
    
    final tasks = currentState.tareas;
    final newIndex = indice + offset;

    if (newIndex >= 0 && newIndex < tasks.length) {
      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => TaskDetailScreen(
            task: tasks[newIndex],
            indice: newIndex,
            onTaskUpdated: onTaskUpdated,
          ),
          transitionsBuilder: (context, animation, _, child) {
            final slideOffset = Offset(offset.sign.toDouble(), 0);
            return SlideTransition(
              position: Tween<Offset>(
                begin: slideOffset,
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    const double sensitivity = 300.0;
    
    if (details.primaryVelocity! > sensitivity) {
      // Deslizamiento hacia la derecha (tarea anterior)
      _navigateToAdjacentTask(context, -1);
    } else if (details.primaryVelocity! < -sensitivity) {
      // Deslizamiento hacia la izquierda (tarea siguiente)
      _navigateToAdjacentTask(context, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditTaskModal(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareTask(context);
                  break;
                case 'duplicate':
                  _duplicateTask(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Compartir'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Duplicar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TareasBloc, TareasState>(
        builder: (context, state) {
          return GestureDetector(
            onHorizontalDragEnd: (details) => _handleSwipe(context, details),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: CommonWidgetsHelper.buildRoundedBorder(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen de la tarea
                    TaskImage(randomIndex: indice, height: 250),
                    
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título y tag de tipo
                          Row(
                            children: [
                              Expanded(
                                child: CommonWidgetsHelper.buildBoldTitle(task.titulo),
                              ),
                              _buildTaskTypeTag(),
                            ],
                          ),
                          CommonWidgetsHelper.buildSpacing(),

                          // Descripción
                          if (task.descripcion != null && task.descripcion!.isNotEmpty) ...[
                            _buildSectionTitle('Descripción'),
                            const SizedBox(height: 8),
                            Text(
                              task.descripcion!,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            CommonWidgetsHelper.buildSpacing(),
                          ],

                          // Información de fechas
                          _buildDateInfo(),
                          CommonWidgetsHelper.buildSpacing(),

                          // Usuario asignado
                          _buildUserInfo(),
                          CommonWidgetsHelper.buildSpacing(),

                          // Navegación entre tareas
                          _buildNavigationButtons(context, state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskTypeTag() {
    Color backgroundColor;
    IconData icon;
    
    switch (task.tipo) {
      case 'urgente':
        backgroundColor = Colors.redAccent;
        icon = Icons.warning;
        break;
      case 'importante':
        backgroundColor = Colors.orange;
        icon = Icons.star;
        break;
      default:
        backgroundColor = Colors.blueAccent;
        icon = Icons.task;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            task.tipo.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDateInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Información de Fechas'),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (task.fecha != null)
                  _buildDateRow(
                    'Fecha de creación',
                    DateFormat('dd/MM/yyyy HH:mm').format(task.fecha!),
                    Icons.access_time,
                    Colors.blue,
                  ),
                if (task.fecha != null && task.fechaLimite != null)
                  const Divider(),
                if (task.fechaLimite != null)
                  _buildDateRow(
                    'Fecha límite',
                    DateFormat('dd/MM/yyyy').format(task.fechaLimite!),
                    Icons.schedule,
                    _getDateLimitColor(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(String label, String date, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            date,
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }

  Color _getDateLimitColor() {
    if (task.fechaLimite == null) return Colors.grey;
    
    final now = DateTime.now();
    final daysUntilLimit = task.fechaLimite!.difference(now).inDays;
    
    if (daysUntilLimit < 0) return Colors.red; // Vencida
    if (daysUntilLimit <= 1) return Colors.orange; // Próxima a vencer
    return Colors.green; // A tiempo
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Usuario Asignado'),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                task.usuario.isNotEmpty ? task.usuario[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(task.usuario),
            subtitle: const Text('Usuario responsable'),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context, TareasState state) {
    final tasks = state.tareas;
    final canGoPrevious = indice > 0;
    final canGoNext = indice < tasks.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: canGoPrevious 
              ? () => _navigateToAdjacentTask(context, -1)
              : null,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Anterior'),
        ),
        Text(
          '${indice + 1} de ${tasks.length}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        ElevatedButton.icon(
          onPressed: canGoNext 
              ? () => _navigateToAdjacentTask(context, 1)
              : null,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Siguiente'),
        ),
      ],
    );
  }

  void _showEditTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Tarea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TaskForm(
              task: task,
              onSave: (updatedTask) {
                if (onTaskUpdated != null) {
                  onTaskUpdated!(updatedTask);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Volver a la lista
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareTask(BuildContext context) {
    final taskInfo = '''
Tarea: ${task.titulo}
Tipo: ${task.tipo}
${task.descripcion != null ? 'Descripción: ${task.descripcion}\n' : ''}
${task.fechaLimite != null ? 'Fecha límite: ${DateFormat('dd/MM/yyyy').format(task.fechaLimite!)}\n' : ''}
Usuario: ${task.usuario}
''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartir Tarea'),
        content: SingleChildScrollView(
          child: Text(taskInfo),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              // Aquí podrías integrar con Share package o copiar al clipboard
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Información copiada')),
              );
            },
            child: const Text('Copiar'),
          ),
        ],
      ),
    );
  }

  void _duplicateTask(BuildContext context) {
    final duplicatedTask = Task(
      usuario: task.usuario,
      titulo: '${task.titulo} (Copia)',
      descripcion: task.descripcion,
      tipo: task.tipo,
      fechaLimite: task.fechaLimite,
      fecha: DateTime.now(),
    );

    if (onTaskUpdated != null) {
      onTaskUpdated!(duplicatedTask);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarea duplicada exitosamente')),
    );
  }
}