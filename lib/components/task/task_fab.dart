import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';

class TaskFAB extends StatelessWidget {
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
            return FloatingActionButton(
              heroTag: 'addTaskButton',
              onPressed: state.status == TareasStatus.loading ? null : onPressed,
              backgroundColor: state.status == TareasStatus.loading ? Colors.grey : null,
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
      ),
    );
  }
}
