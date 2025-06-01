import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_event.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_state.dart';
import 'package:afranco/components/task/progreso_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_bloc.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    // Cargar las tareas al inicializar
    context.read<TareasBloc>().add(const TareasLoadEvent());

    // Listener para el scroll
    _scrollController.addListener(_onScroll);
  }

  void _actualizarContadores(List<Task> tareas) {
    final total = tareas.length;
    final completadas = tareas.where((t) => t.completada).length;

    context.read<TareaContadorBloc>().add(
      ActualizarContadores(completadas, total),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Mostrar FAB cuando está en el top o scrolling hacia arriba
    // Ocultar FAB cuando scrolling hacia abajo
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() {
          _showFab = false;
        });
      }
    }
  }

  void _mostrarSnackBar(String mensaje, bool esCompletada) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              esCompletada ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(mensaje),
          ],
        ),
        backgroundColor: esCompletada ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        actions: [
          BlocBuilder<TareasBloc, TareasState>(
            builder: (context, state) {
              return IconButton(
                icon:
                    state.status == TareasStatus.loading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.refresh),
                onPressed:
                    state.status == TareasStatus.loading
                        ? null
                        : () {
                          context.read<TareasBloc>().add(
                            const TareasLoadEvent(),
                          );
                        },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // WIDGET DE PROGRESO EN LA PARTE SUPERIOR
          BlocBuilder<TareaContadorBloc, TareaContadorState>(
            builder: (context, contadorState) {
              return ProgresoWidget(
                progreso: contadorState.progreso,
                tareasCompletadas: contadorState.tareasCompletadas,
                totalTareas: contadorState.totalTareas,
              );
            },
          ),

          // LISTA DE TAREAS
          Expanded(
            child: BlocConsumer<TareasBloc, TareasState>(
              listener: (context, state) {
                // ACTUALIZAR CONTADORES CUANDO CAMBIAN LAS TAREAS
                _actualizarContadores(state.tareas);

                // MANEJO DE MENSAJES DE ESTADO
                if (state.status == TareasStatus.error &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Reintentar',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<TareasBloc>().add(
                            const TareasLoadEvent(),
                          );
                        },
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
              builder: (context, state) {
                // Mostrar indicador de carga
                if (state.status == TareasStatus.loading &&
                    state.tareas.isEmpty) {
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
                if (state.tareas.isEmpty &&
                    state.status != TareasStatus.loading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          AppConstants.emptyList,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        /*FloatingActionButton(
                          heroTag: 'emptyListAddButton',
                          onPressed: () => _showAddTaskModal(context),
                          child: const Icon(Icons.add),
                        ),*/
                      ],
                    ),
                  );
                }

                // Mostrar lista de tareas
                return Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      itemCount: state.tareas.length,
                      itemBuilder: (context, index) {
                        final task = state.tareas[index];
                        return _buildTaskItem(task, index, context);
                      },
                    ),
                    if (state.status == TareasStatus.loading &&
                        state.tareas.isNotEmpty)
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
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _showFab ? 1.0 : 0.0,
          child: BlocBuilder<TareasBloc, TareasState>(
            builder: (context, state) {
              return FloatingActionButton(
                heroTag: 'addTaskButton',
                onPressed:
                    state.status == TareasStatus.loading
                        ? null
                        : () => _showAddTaskModal(context),
                backgroundColor:
                    state.status == TareasStatus.loading ? Colors.grey : null,
                child:
                    state.status == TareasStatus.loading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.add),
              );
            },
          ),
        ),
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
                  child:Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color:Colors.white),
                    ),
                  ),
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
                leading: Checkbox(
                  value: task.completada,
                  onChanged: (bool? value) {
                    // TOGGLE DE ESTADO COMPLETADA
                    context.read<TareasBloc>().add(
                      TareasToggleCompletedEvent(index: index),
                    );

                    // MOSTRAR SNACKBAR
                    _mostrarSnackBar(
                      value!
                          ? '¡Tarea completada!'
                          : 'Tarea marcada como pendiente',
                      value,
                    );
                  },
                  activeColor: Colors.green,
                ),
                contentPadding: const EdgeInsets.all(16),
                title: CommonWidgetsHelper.buildBoldTitle(
                  task.titulo,
                  // APLICAR TACHADO SI ESTÁ COMPLETADA
                  /*style: TextStyle(
                    decoration: task.completada ? TextDecoration.lineThrough : null,
                    color: task.completada ? Colors.grey : null,
                  ),*/
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgetsHelper.buildSpacing(),
                    CommonWidgetsHelper.buildInfoLines(
                      line1: task.descripcion ?? 'Sin descripción',
                      line2: '',
                      line3:
                          task.fechaLimite != null
                              ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(task.fechaLimite!)
                              : 'Sin fecha límite',
                      icon: task.tipo == 'urgente' ? Icons.warning : Icons.task,
                      iconColor:
                          task.tipo == 'urgente' ? Colors.red : Colors.blue,

                      // APLICAR ESTILO GRIS SI ESTÁ COMPLETADA
                      /*textStyle: TextStyle(
                        color: task.completada ? Colors.grey : Colors.black87,
                      ),*/
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

  // Resto de métodos permanecen igual...
  void _navigateToTaskDetail(BuildContext context, Task task, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TaskDetailScreen(
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
      builder:
          (context) => Padding(
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
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
            context.read<TareasBloc>().add(TareasAddEvent(tarea: task));
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
