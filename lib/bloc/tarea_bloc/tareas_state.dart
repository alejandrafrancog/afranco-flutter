import 'package:equatable/equatable.dart';
import 'package:afranco/domain/task.dart';

enum TareasStatus { initial, loading, loadingMore, loaded, error }

class TareasState extends Equatable {
  final List<Task> tareas;
  final TareasStatus status;
  final String? errorMessage;
  final bool hasReachedEnd;

  const TareasState({
    this.tareas = const [],
    this.status = TareasStatus.initial,
    this.errorMessage,
    this.hasReachedEnd = false,
  });

  TareasState copyWith({
    List<Task>? tareas,
    TareasStatus? status,
    String? errorMessage,
    bool? hasReachedEnd,
  }) {
    return TareasState(
      tareas: tareas ?? this.tareas,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [tareas, status, errorMessage, hasReachedEnd];
}