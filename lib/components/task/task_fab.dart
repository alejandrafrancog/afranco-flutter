import 'package:afranco/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/helpers/task_limit_helper.dart';

class TaskFAB extends StatelessWidget with TaskLimitHelper {
  final bool showFab;
  final VoidCallback onPressed;

  const TaskFAB({
    super.key,
    required this.showFab,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showFab ? 1.0 : 0.0,
        child: BlocBuilder<TareasBloc, TareasState>(
          builder: (context, state) {
            bool isLoading = state.status == TareasStatus.loading;
            bool isAtLimit = hasReachedTaskLimit(state.tareas.length);
            
            return FloatingActionButton.extended(
              heroTag: 'addTaskButton',
              onPressed: isLoading ? null : onPressed,
              backgroundColor: _getFabBackgroundColor(isLoading, isAtLimit),
              foregroundColor: Colors.white,
              icon: _getFabIcon(isLoading, isAtLimit),
              label: _getFabLabel(isLoading, isAtLimit, state.tareas.length),
              elevation: isAtLimit ? 2 : 6,
              tooltip: isAtLimit 
                  ? '⚠️ Límite de tareas alcanzado'
                  : 'Agregar nueva tarea',
            );
          },
        ),
      ),
    );
  }

  Color _getFabBackgroundColor(bool isLoading, bool isAtLimit) {
    if (isLoading) return Colors.grey;
    if (isAtLimit) return Colors.red.shade400;
    return AppColors.autogestion; // Color por defecto
  }

  Widget _getFabIcon(bool isLoading, bool isAtLimit) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    if (isAtLimit) {
      return const Icon(Icons.block, size: 20);
    }
    
    return const Icon(Icons.add, size: 20);
  }

  Widget _getFabLabel(bool isLoading, bool isAtLimit, int taskCount) {
    if (isLoading) {
      return const Text('Cargando...');
    }
    
    if (isAtLimit) {
      return const Text('Límite alcanzado');
    }
    
    int remaining = getRemainingTasks(taskCount);
    return Text('Agregar${remaining <= 1 ? ' ($remaining)' : ''}');
  }
}
