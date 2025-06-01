import 'package:afranco/domain/comentario.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_event.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_state.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:afranco/data/comentario_repository.dart';
import 'package:afranco/core/comentario_cache_service.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository comentarioRepository;
  final ComentarioCacheService _cacheService;

  ComentarioBloc({
    ComentarioRepository? comentarioRepository,
    ComentarioCacheService? cacheService,
  }) : comentarioRepository =
           comentarioRepository ?? di<ComentarioRepository>(),
       _cacheService = cacheService ?? di<ComentarioCacheService>(),
       super(ComentarioInitial()) {
    on<LoadComentarios>(_onLoadComentarios);
    on<AddComentario>(_onAddComentario);
    on<GetNumeroComentarios>(_onGetNumeroComentarios);
    on<BuscarComentarios>(_onBuscarComentarios);
    on<OrdenarComentarios>(_onOrdenarComentarios);
    on<AddReaccion>(_onAddReaccion);
    on<AddSubcomentario>(_onAddSubcomentario);
    on<InvalidateCache>(_onInvalidateCache);
    on<AddReaccionSubcomentario>(_onAddReaccionSubcomentario);
  }

  Future<void> _onLoadComentarios(
    LoadComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());

      // Usamos el servicio de cache para obtener los comentarios
      final comentarios = await _cacheService.getComentariosPorNoticia(
        event.noticiaId,
      );

      debugPrint(
        '📝 Cargados ${comentarios.length} comentarios para la noticia ${event.noticiaId}',
      );
      emit(ComentarioLoaded(comentariosList: comentarios));
    } on ApiException catch (e) {
      emit(
        ComentarioError(
          errorMessage: e.message ?? 'Error desconocido en ComentarioBloc',
        ),
      );
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage: 'Error al cargar comentarios: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddComentario(
    AddComentario event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      // Guardamos el estado actual antes de emitir ComentarioLoading
      final currentState = state;
      emit(ComentarioLoading());

      // Utilizamos el servicio de cache para agregar el comentario
      await _cacheService.agregarComentario(
        event.noticiaId,
        event.texto,
        event.autor,
        event.fecha,
      );

      // Obtenemos los comentarios actualizados desde el cache
      final comentarios = await _cacheService.getComentariosPorNoticia(
        event.noticiaId,
      );
      emit(ComentarioLoaded(comentariosList: comentarios));

      // Actualizar también el número de comentarios
      final numeroComentarios = await _cacheService.getNumeroComentarios(
        event.noticiaId,
      );

      // Emitimos el nuevo estado con el número de comentarios actualizado
      emit(
        NumeroComentariosLoaded(
          noticiaId: event.noticiaId,
          numeroComentarios: numeroComentarios,
        ),
      );

      // Si había un estado ComentarioLoaded, lo restauramos pero con la nueva lista
      if (currentState is ComentarioLoaded) {
        emit(ComentarioLoaded(comentariosList: comentarios));
      }
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage: 'Error al agregar el comentario: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetNumeroComentarios(
    GetNumeroComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());

      // Utilizamos el servicio de cache para obtener el número de comentarios
      final numeroComentarios = await _cacheService.getNumeroComentarios(
        event.noticiaId,
      );

      emit(
        NumeroComentariosLoaded(
          noticiaId: event.noticiaId,
          numeroComentarios: numeroComentarios,
        ),
      );
    } on ApiException catch (e) {
      emit(ComentarioError(errorMessage: e.message ?? 'Error desconocido'));
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage:
              'Error al obtener número de comentarios: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onBuscarComentarios(
    BuscarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());

      // Obtenemos los comentarios desde el cache
      final comentarios = await _cacheService.getComentariosPorNoticia(
        event.noticiaId,
      );

      // Filtrar los comentarios según el criterio
      final comentariosFiltrados =
          comentarios.where((comentario) {
            final textoBuscado = event.criterioBusqueda.toLowerCase();
            final textoComentario = comentario.texto.toLowerCase();
            final autorComentario = comentario.autor.toLowerCase();

            return textoComentario.contains(textoBuscado) ||
                autorComentario.contains(textoBuscado);
          }).toList();

      // Emitir el estado con comentarios filtrados
      emit(ComentarioLoaded(comentariosList: comentariosFiltrados));
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage: 'Error al buscar comentarios: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onOrdenarComentarios(
    OrdenarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    if (state is ComentarioLoaded) {
      final currentState = state as ComentarioLoaded;
      final comentarios = List<Comentario>.from(
        currentState.comentariosList,
      ); // Crear una copia para no modificar la lista original

      comentarios.sort((a, b) {
        return event.ascendente
            ? a.fecha.compareTo(b.fecha) // Orden ascendente
            : b.fecha.compareTo(a.fecha); // Orden descendente
      });

      emit(ComentarioLoaded(comentariosList: comentarios));
    }
  }

  Future<void> _onAddReaccion(
    AddReaccion event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      // Guardamos el estado actual
      final currentState = state;

      // Emitimos un estado de carga optimista mostrando la reacción
      if (currentState is ComentarioLoaded) {
        final comentarios = List<Comentario>.from(currentState.comentariosList);
        final comentarioIndex = comentarios.indexWhere(
          (c) => c.id == event.comentarioId,
        );
        // Si encontramos el comentario, actualizamos localmente antes de hacer la llamada API
        if (comentarioIndex != -1) {
          final comentario = comentarios[comentarioIndex];
          late Comentario comentarioActualizado;

          if (event.tipoReaccion == 'like') {
            comentarioActualizado = Comentario(
              id: comentario.id,
              noticiaId: comentario.noticiaId,
              texto: comentario.texto,
              autor: comentario.autor,
              fecha: comentario.fecha,
              likes: comentario.likes + 1, // Incrementamos optimistamente
              dislikes: comentario.dislikes,
              subcomentarios: comentario.subcomentarios,
              isSubComentario: comentario.isSubComentario,
              idSubComentario: comentario.idSubComentario,
            );
          } else {
            comentarioActualizado = Comentario(
              id: comentario.id,
              noticiaId: comentario.noticiaId,
              texto: comentario.texto,
              autor: comentario.autor,
              fecha: comentario.fecha,
              likes: comentario.likes,
              dislikes: comentario.dislikes + 1, // Incrementamos optimistamente
              subcomentarios: comentario.subcomentarios,
              isSubComentario: comentario.isSubComentario,
              idSubComentario: comentario.idSubComentario,
            );
          }

          comentarios[comentarioIndex] = comentarioActualizado;
          emit(ComentarioLoaded(comentariosList: comentarios));
        }
      }

      // Llamamos al servicio de cache para persistir el cambio
      await _cacheService.reaccionarComentario(
        noticiaId: event.noticiaId,
        comentarioId: event.comentarioId,
        tipoReaccion: event.tipoReaccion,
      );

      // Recargamos los comentarios para asegurar los datos más recientes
      final comentariosActualizados = await _cacheService
          .getComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentariosList: comentariosActualizados));
    } catch (e) {
      // Si ocurre un error, intentamos recargar los comentarios para restaurar el estado
      try {
        final comentarios = await _cacheService.getComentariosPorNoticia(
          event.noticiaId,
        );
        emit(ComentarioLoaded(comentariosList: comentarios));
      } catch (_) {
        // Si incluso la recarga falla, mostramos el error
        emit(
          ComentarioError(
            errorMessage:
                'Error al agregar reacción. Intenta de nuevo: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> _onAddSubcomentario(
    AddSubcomentario event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      // Mostrar estado de carga
      emit(ComentarioLoading());

      // Llamar al servicio de cache para agregar el subcomentario
      final resultado = await _cacheService.agregarSubcomentario(
        noticiaId: event.noticiaId,
        comentarioId: event.comentarioId,
        texto: event.texto,
        autor: event.autor,
      );

      if (resultado['success'] == true) {
        // Recargar comentarios usando el servicio de cache
        final comentarios = await _cacheService.getComentariosPorNoticia(
          event.noticiaId,
        );
        emit(ComentarioLoaded(comentariosList: comentarios));
      } else {
        // Si hubo un error, mostrar el mensaje de error
        emit(ComentarioError(errorMessage: resultado['message']));
      }
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage: 'Error al agregar subcomentario: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onInvalidateCache(
    InvalidateCache event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      // Invalidamos la cache para la noticia específica
      _cacheService.invalidateCache(event.noticiaId);

      // Recargamos los comentarios desde la API
      emit(ComentarioLoading());
      final comentarios = await _cacheService.getComentariosPorNoticia(
        event.noticiaId,
      );
      emit(ComentarioLoaded(comentariosList: comentarios));
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage: 'Error al invalidar cache: ${e.toString()}',
        ),
      );
    }
  }
  // Agregar este handler al constructor del ComentarioBloc

  // Solo mostraré los métodos refactorizados y los nuevos métodos auxiliares

  Future<void> _onAddReaccionSubcomentario(
    AddReaccionSubcomentario event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      final currentState = state;

      // Actualización optimista del estado
      if (currentState is ComentarioLoaded) {
        final comentariosActualizados = _actualizarSubcomentarioOptimista(
          currentState.comentariosList,
          event.subcomentarioId,
          event.tipoReaccion,
        );

        if (comentariosActualizados != null) {
          emit(ComentarioLoaded(comentariosList: comentariosActualizados));
        }
      }

      // Persistir cambio en el cache
      await _cacheService.reaccionarSubcomentario(
        noticiaId: event.noticiaId,
        subcomentarioId: event.subcomentarioId,
        tipoReaccion: event.tipoReaccion,
      );

      // Recargar comentarios actualizados
      await _recargarComentarios(event.noticiaId, emit);
    } catch (e) {
      await _manejarErrorReaccionSubcomentario(event.noticiaId, emit, e);
    }
  }

  /// Actualiza optimistamente el subcomentario en la lista de comentarios
  List<Comentario>? _actualizarSubcomentarioOptimista(
    List<Comentario> comentarios,
    String subcomentarioId,
    String tipoReaccion,
  ) {
    final comentariosCopia = List<Comentario>.from(comentarios);

    for (int i = 0; i < comentariosCopia.length; i++) {
      final comentario = comentariosCopia[i];

      if (_tieneSubcomentarios(comentario)) {
        final subcomentarioActualizado = _buscarYActualizarSubcomentario(
          comentario.subcomentarios!,
          subcomentarioId,
          tipoReaccion,
        );

        if (subcomentarioActualizado != null) {
          comentariosCopia[i] = comentario.copyWith(
            subcomentarios: subcomentarioActualizado,
          );
          return comentariosCopia;
        }
      }
    }

    return null; // No se encontró el subcomentario
  }

  /// Verifica si el comentario tiene subcomentarios
  bool _tieneSubcomentarios(Comentario comentario) {
    return comentario.subcomentarios?.isNotEmpty == true;
  }

  /// Busca y actualiza un subcomentario específico en la lista
  List<Comentario>? _buscarYActualizarSubcomentario(
    List<Comentario> subcomentarios,
    String subcomentarioId,
    String tipoReaccion,
  ) {
    final subcomentariosCopia = List<Comentario>.from(subcomentarios);

    for (int j = 0; j < subcomentariosCopia.length; j++) {
      if (subcomentariosCopia[j].id == subcomentarioId) {
        subcomentariosCopia[j] = _crearSubcomentarioConReaccion(
          subcomentariosCopia[j],
          tipoReaccion,
        );
        return subcomentariosCopia;
      }
    }

    return null; // No se encontró el subcomentario
  }

  /// Crea una nueva instancia del subcomentario con la reacción actualizada
  Comentario _crearSubcomentarioConReaccion(
    Comentario subcomentario,
    String tipoReaccion,
  ) {
    return Comentario(
      id: subcomentario.id,
      noticiaId: subcomentario.noticiaId,
      texto: subcomentario.texto,
      autor: subcomentario.autor,
      fecha: subcomentario.fecha,
      likes: _calcularNuevosLikes(subcomentario.likes, tipoReaccion),
      dislikes: _calcularNuevosDislikes(subcomentario.dislikes, tipoReaccion),
      subcomentarios: subcomentario.subcomentarios,
      isSubComentario: subcomentario.isSubComentario,
      idSubComentario: subcomentario.idSubComentario,
    );
  }

  /// Calcula el nuevo número de likes basado en el tipo de reacción
  int _calcularNuevosLikes(int likesActuales, String tipoReaccion) {
    return tipoReaccion == 'like' ? likesActuales + 1 : likesActuales;
  }

  /// Calcula el nuevo número de dislikes basado en el tipo de reacción
  int _calcularNuevosDislikes(int dislikesActuales, String tipoReaccion) {
    return tipoReaccion == 'dislike' ? dislikesActuales + 1 : dislikesActuales;
  }

  /// Recarga los comentarios desde el cache y emite el nuevo estado
  Future<void> _recargarComentarios(
    String noticiaId,
    Emitter<ComentarioState> emit,
  ) async {
    final comentariosActualizados = await _cacheService
        .getComentariosPorNoticia(noticiaId);
    emit(ComentarioLoaded(comentariosList: comentariosActualizados));
  }

  /// Maneja los errores que ocurren al agregar reacción a subcomentario
  Future<void> _manejarErrorReaccionSubcomentario(
    String noticiaId,
    Emitter<ComentarioState> emit,
    Object error,
  ) async {
    try {
      // Intentar recargar comentarios para restaurar el estado
      await _recargarComentarios(noticiaId, emit);
    } catch (_) {
      // Si incluso la recarga falla, mostrar el error
      emit(
        ComentarioError(
          errorMessage:
              'Error al agregar reacción al subcomentario. Intenta de nuevo: ${error.toString()}',
        ),
      );
    }
  }
}
