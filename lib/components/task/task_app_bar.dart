import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<TareasBloc, TareasState>(
        builder: (context, state) {
          return Text(
            '${AppConstantes.titleAppBar} - Total: ${state.tareas.length}',
          );
        },
      ),
      centerTitle: true,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

