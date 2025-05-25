import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_event.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_state.dart';
import 'package:afranco/data/task_repository.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class TareasBloc extends Bloc<TareasEvent, TareasState> {
  final TaskRepository _taskRepository = di<TaskRepository>();

  TareasBloc() : super(const TareasState()) {
    on<TareasLoadEvent>(_onLoadTareas);
    on<TareasAddEvent>(_onAddTarea);
    on<TareasUpdateEvent>(_onUpdateTarea);
    on<TareasDeleteEvent>(_onDeleteTarea);
  }

  Future<void> _onLoadTareas(
    TareasLoadEvent event,
    Emitter<TareasState> emit,
  ) async {
    emit(state.copyWith(
      status: TareasStatus.loading,
      errorMessage: null,
    ));

    try {
      final tareas = await _taskRepository.obtenerTareas(forzarRecarga: false);

      emit(state.copyWith(
        status: TareasStatus.loaded,
        tareas: tareas,
        hasReachedEnd: tareas.length < event.limite,
      ));
    } catch (e) {
      print('Error en _onLoadTareas: $e'); // Debug logging
      String mensaje = 'Error al cargar las tareas';
      if (e is ApiException) {
        mensaje = e.message ?? 'Error al cargar las tareas';
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onAddTarea(
    TareasAddEvent event,
    Emitter<TareasState> emit,
  ) async {
    // CORRECCIÓN 1: Emitir estado de loading para mostrar feedback al usuario
    emit(state.copyWith(
      status: TareasStatus.loading,
      errorMessage: null,
    ));

    try {
      print('Intentando agregar tarea: ${event.tarea.titulo}'); // Debug
      
      // CORRECCIÓN 2: Validar que la tarea tenga datos mínimos requeridos
      if (event.tarea.titulo.isEmpty) {
        throw ApiException(
          message: 'El título de la tarea es obligatorio',
          statusCode: 400,
        );
      }

      final nuevaTarea = await _taskRepository.agregarTarea(event.tarea);
      
      print('Tarea agregada exitosamente: ${nuevaTarea.id}'); // Debug

      // CORRECCIÓN 3: Asegurar que el estado se emita correctamente
      emit(state.copyWith(
        status: TareasStatus.loaded, // ← Importante: cambiar a loaded
        tareas: [nuevaTarea, ...state.tareas],
        errorMessage: null, // Limpiar cualquier error previo
      ));
      
    } catch (e) {
      print('Error detallado en _onAddTarea: $e'); // Debug detallado
      print('Stack trace: ${StackTrace.current}'); // Stack trace para debugging
      
      String mensaje = 'Error al crear la tarea';
      if (e is ApiException) {
        mensaje = e.message ?? 'Error desconocido en la API';
      } else {
        mensaje = 'Error inesperado: ${e.toString()}';
      }
      
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onUpdateTarea(
    TareasUpdateEvent event,
    Emitter<TareasState> emit,
  ) async {
    // Emitir loading state
    emit(state.copyWith(
      status: TareasStatus.loading,
      errorMessage: null,
    ));

    try {
      print('Actualizando tarea en índice: ${event.index}'); // Debug
      
      final tareaActualizada = await _taskRepository.actualizarTarea(event.tarea);

      // Creamos una nueva lista reemplazando la tarea actualizada
      final nuevasTareas = List<Task>.from(state.tareas);
      if (event.index >= 0 && event.index < nuevasTareas.length) {
        nuevasTareas[event.index] = tareaActualizada;
        
        emit(state.copyWith(
          status: TareasStatus.loaded,
          tareas: nuevasTareas,
          errorMessage: null,
        ));
        
        print('Tarea actualizada exitosamente'); // Debug
      } else {
        throw ApiException(
          message: 'Índice de tarea inválido',
          statusCode: 400,
        );
      }
      
    } catch (e) {
      print('Error en _onUpdateTarea: $e'); // Debug
      String mensaje = 'Error al actualizar la tarea';
      if (e is ApiException) {
        mensaje = e.message ?? 'Error genérico';
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onDeleteTarea(
    TareasDeleteEvent event,
    Emitter<TareasState> emit,
  ) async {
    try {
      print('Eliminando tarea en índice: ${event.index}'); // Debug
      
      // Validar índice
      if (event.index < 0 || event.index >= state.tareas.length) {
        throw ApiException(
          message: 'Índice de tarea inválido para eliminación',
          statusCode: 400,
        );
      }

      // Obtenemos el id de la tarea a eliminar
      final String? tareaId = state.tareas[event.index].id;

      if (tareaId != null) {
        await _taskRepository.eliminarTarea(tareaId);

        // Eliminamos la tarea de la lista por índice
        final nuevasTareas = List<Task>.from(state.tareas);
        nuevasTareas.removeAt(event.index);

        emit(state.copyWith(
          status: TareasStatus.loaded,
          tareas: nuevasTareas,
          errorMessage: null,
        ));
        
        print('Tarea eliminada exitosamente'); // Debug
      } else {
        throw ApiException(
          message: 'No se puede eliminar una tarea sin ID',
          statusCode: 400,
        );
      }
    } catch (e) {
      print('Error en _onDeleteTarea: $e'); // Debug
      String mensaje = 'Error al eliminar la tarea';
      if (e is ApiException) {
        mensaje = e.message ?? 'Error genérico';
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  // CORRECCIÓN 4: Método adicional para limpiar errores
  void clearError() {
    (state.copyWith(
      status: TareasStatus.loaded,
      errorMessage: null,
    ));
  }

  // CORRECCIÓN 5: Método para refrescar la lista completa
  void refreshTareas() {
    add(const TareasLoadEvent());
  }
}