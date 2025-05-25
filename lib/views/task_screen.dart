import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/helpers/common_widgets_helper.dart';
import 'package:afranco/components/task/task_image.dart';
import 'package:afranco/views/task_detail_screen.dart';
import 'package:afranco/components/task/task_form.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las tareas al inicializar
    context.read<TareasBloc>().add(const TareasLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TareasBloc, TareasState>(
          builder: (context, state) {
            return Text(
              '${AppConstants.titleAppBar} - Total: ${state.tareas.length}',
            );
          },
        ),
        centerTitle: true,
        // MEJORA 1: Botón de refresh en la AppBar
        actions: [
          BlocBuilder<TareasBloc, TareasState>(
            builder: (context, state) {
              return IconButton(
                icon: state.status == TareasStatus.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onPressed: state.status == TareasStatus.loading
                    ? null
                    : () {
                        context.read<TareasBloc>().add(const TareasLoadEvent());
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TareasBloc, TareasState>(
        listener: (context, state) {
          // MEJORA 2: Mejor manejo de mensajes de estado
          if (state.status == TareasStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Reintentar',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<TareasBloc>().add(const TareasLoadEvent());
                  },
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
          
          // MEJORA 3: Mensaje de éxito al agregar tarea
          if (state.status == TareasStatus.loaded && 
              state.tareas.isNotEmpty) {
            // Este es un hack simple para detectar si se agregó una tarea
            // En una implementación más robusta, podrías usar un estado específico
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                // Solo mostrar si hay tareas y no es la carga inicial
                final shouldShowSuccess = state.tareas.length > 0;
                if (shouldShowSuccess) {
                  // Mostrar mensaje de éxito de manera sutil
                  print('Tareas cargadas/actualizadas correctamente');
                }
              }
            });
          }
        },
        builder: (context, state) {
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    AppConstants.emptyList,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // MEJORA 4: Botón para agregar primera tarea
                  ElevatedButton.icon(
                    onPressed: () => _showAddTaskModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar primera tarea'),
                  ),
                ],
              ),
            );
          }

          // Mostrar lista de tareas con indicador de carga superpuesto
          return Stack(
            children: [
              ListView.builder(
                itemCount: state.tareas.length,
                itemBuilder: (context, index) {
                  final task = state.tareas[index];
                  return _buildTaskItem(task, index, context);
                },
              ),
              // MEJORA 5: Indicador de carga superpuesto durante operaciones
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
        },
      ),
      floatingActionButton: BlocBuilder<TareasBloc, TareasState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: state.status == TareasStatus.loading
                ? null
                : () => _showAddTaskModal(context),
            backgroundColor: state.status == TareasStatus.loading
                ? Colors.grey
                : null,
            child: state.status == TareasStatus.loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(Task task, int index, BuildContext context) {
    return Dismissible(
      key: Key(task.id ?? 'task_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar eliminación'),
              content: Text(
                '¿Estás seguro de que quieres eliminar "${task.titulo}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<TareasBloc>().add(TareasDeleteEvent(index: index));
        _showDeleteSnackbar(context, task, index);
      },
      child: GestureDetector(
        onTap: () => _navigateToTaskDetail(context, task, index),
        child: Container(
          decoration: CommonWidgetsHelper.buildRoundedBorder(),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              TaskImage(randomIndex: index, height: 150),
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: CommonWidgetsHelper.buildBoldTitle(task.titulo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgetsHelper.buildSpacing(),
                    CommonWidgetsHelper.buildInfoLines(
                      line1: task.descripcion ?? 'Sin descripción',
                      line2: task.descripcion ?? '',
                      line3: task.fechaLimite != null
                          ? DateFormat('dd/MM/yyyy').format(task.fechaLimite!)
                          : 'Sin fecha límite',
                      icon: task.tipo == 'urgente' ? Icons.warning : Icons.task,
                      iconColor:
                          task.tipo == 'urgente' ? Colors.red : Colors.blue,
                    ),
                    CommonWidgetsHelper.buildSpacing(),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditTaskModal(context, task, index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context, Task task, int index) {
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

  void _showAddTaskModal(BuildContext context) {
    print('Abriendo modal para agregar tarea'); // Debug
    
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
              'Nueva Tarea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TaskForm(
              onSave: (newTask) {
                print('Guardando nueva tarea: ${newTask.titulo}'); // Debug
                
                // MEJORA 6: Validación adicional antes de enviar
                if (newTask.titulo.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El título de la tarea es obligatorio'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                context.read<TareasBloc>().add(
                  TareasAddEvent(tarea: newTask),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskModal(BuildContext context, Task task, int index) {
    print('Abriendo modal para editar tarea: ${task.titulo}'); // Debug
    
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
                print('Actualizando tarea: ${updatedTask.titulo}'); // Debug
                context.read<TareasBloc>().add(
                  TareasUpdateEvent(tarea: updatedTask, index: index),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSnackbar(BuildContext context, Task task, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea eliminada: ${task.titulo}'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            // Para deshacer, necesitarías volver a añadir la tarea
            context.read<TareasBloc>().add(TareasAddEvent(tarea: task));
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}