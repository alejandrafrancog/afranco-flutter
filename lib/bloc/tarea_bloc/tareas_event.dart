import 'package:equatable/equatable.dart';
import 'package:afranco/domain/task.dart';

abstract class TareasEvent extends Equatable {
  const TareasEvent();

  @override
  List<Object?> get props => [];
}

class TareasLoadEvent extends TareasEvent {
  final int limite;

  const TareasLoadEvent({this.limite = 5});

  @override
  List<Object?> get props => [limite];
}

class TareasAddEvent extends TareasEvent {
  final Task tarea;

  const TareasAddEvent({required this.tarea});

  @override
  List<Object?> get props => [tarea];
}

class TareasUpdateEvent extends TareasEvent {
  final int index;
  final Task tarea;

  const TareasUpdateEvent({required this.index, required this.tarea});

  @override
  List<Object?> get props => [index, tarea];
}

class TareasDeleteEvent extends TareasEvent {
  final int index;

  const TareasDeleteEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

// NUEVO EVENTO: Para completar/descompletar una tarea
class CompletarTareaEvent extends TareasEvent {
  final int index;
  final bool completada;

  const CompletarTareaEvent({
    required this.index,
    required this.completada,
  });

  @override
  List<Object?> get props => [index, completada];
}
class TareasToggleCompletedEvent extends TareasEvent {
  final int index;
  const TareasToggleCompletedEvent({required this.index});
}
