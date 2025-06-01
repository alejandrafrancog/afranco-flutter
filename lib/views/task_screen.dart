import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_state.dart';
import 'package:afranco/components/task/progreso_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_bloc.dart';
import 'package:afranco/components/task/task_list_widget.dart';
import 'package:afranco/components/task/task_app_bar.dart';
import 'package:afranco/components/task/task_fab.dart';
import 'package:afranco/helpers/task_modal_helper.dart';
import 'package:afranco/helpers/task_scroll_helper.dart';
import 'package:afranco/helpers/task_counter_helper.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> with TaskScrollHelper, TaskCounterHelper {
  @override
  void initState() {
    super.initState();
    // Cargar las tareas al inicializar
    context.read<TareasBloc>().add(const TareasLoadEvent());
    
    // Configurar el scroll helper
    initScrollHelper();
  }

  @override
  void dispose() {
    disposeScrollHelper();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskAppBar(),
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
                actualizarContadores(context, state.tareas);

                // MANEJO DE MENSAJES DE ESTADO
                _handleStateMessages(context, state);
              },
              builder: (context, state) {
                return TaskListWidget(
                  state: state,
                  scrollController: scrollController,
                  onTaskToggle: (index, value) => _handleTaskToggle(index, value),
                  onTaskEdit: (task, index) => TaskModalHelper.showEditTaskModal(context, task, index),
                  onTaskDelete: (task, index) => _showDeleteSnackbar(context, task, index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: TaskFAB(
        showFab: showFab,
        onPressed: () => TaskModalHelper.showAddTaskModal(context),
      ),
    );
  }

  void _handleStateMessages(BuildContext context, TareasState state) {
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
  }

  void _handleTaskToggle(int index, bool value) {
    context.read<TareasBloc>().add(TareasToggleCompletedEvent(index: index));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(value ? '¡Tarea completada!' : 'Tarea marcada como pendiente'),
          ],
        ),
        backgroundColor: value ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
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

