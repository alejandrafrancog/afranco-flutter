import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_bloc.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_event.dart';

mixin TaskCounterHelper<T extends StatefulWidget> on State<T> {
  void actualizarContadores(BuildContext context, List<Task> tareas) {
    final total = tareas.length;
    final completadas = tareas.where((t) => t.completada).length;

    context.read<TareaContadorBloc>().add(
      ActualizarContadores(completadas, total),
    );
  }
}
