import 'package:equatable/equatable.dart';
import 'package:afranco/domain/task.dart';

enum TareasStatus { 
  initial, 
  loading, 
  loadingMore, 
  loaded, 
  error,
  completando, // Estado para cuando se está completando una tarea
  tareaCompletada // Estado cuando una tarea fue completada exitosamente
}

class TareasState extends Equatable {
  final List<Task> tareas;
  final TareasStatus status;
  final String? errorMessage;
  final bool hasReachedEnd;
  final Task? tareaCompletada; // Nueva propiedad para la tarea recién completada
  final bool? estadoCompletada; // Estado de completado de la tarea recién actualizada

  const TareasState({
    this.tareas = const [],
    this.status = TareasStatus.initial,
    this.errorMessage,
    this.hasReachedEnd = false,
    this.tareaCompletada,
    this.estadoCompletada,
  });

  TareasState copyWith({
    List<Task>? tareas,
    TareasStatus? status,
    String? errorMessage,
    bool? hasReachedEnd,
    Task? tareaCompletada,
    bool? estadoCompletada,
  }) {
    return TareasState(
      tareas: tareas ?? this.tareas,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      tareaCompletada: tareaCompletada ?? this.tareaCompletada,
      estadoCompletada: estadoCompletada ?? this.estadoCompletada,
    );
  }

  @override
  List<Object?> get props => [
    tareas, 
    status, 
    errorMessage, 
    hasReachedEnd, 
    tareaCompletada, 
    estadoCompletada
  ];
}