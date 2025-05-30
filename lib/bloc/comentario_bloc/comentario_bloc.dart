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
  })  : comentarioRepository = comentarioRepository ?? di<ComentarioRepository>(),
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
      final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);

      debugPrint('📝 Cargados ${comentarios.length} comentarios para la noticia ${event.noticiaId}');
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
          errorMessage:
              'Error al cargar comentarios: ${e.toString()}',
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
      final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentariosList: comentarios));

      // Actualizar también el número de comentarios
      final numeroComentarios = await _cacheService.getNumeroComentarios(event.noticiaId);

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
        ComentarioError(errorMessage: 'Error al agregar el comentario: ${e.toString()}'),
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
      final numeroComentarios = await _cacheService.getNumeroComentarios(event.noticiaId);

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
      final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);

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
      final comentariosActualizados = await _cacheService.getComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentariosList: comentariosActualizados));
    } catch (e) {
      // Si ocurre un error, intentamos recargar los comentarios para restaurar el estado
      try {
        final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);
        emit(ComentarioLoaded(comentariosList: comentarios));
      } catch (_) {
        // Si incluso la recarga falla, mostramos el error
        emit(
          ComentarioError(
            errorMessage: 'Error al agregar reacción. Intenta de nuevo: ${e.toString()}',
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
        final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);
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
      final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);
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

Future<void> _onAddReaccionSubcomentario(
  AddReaccionSubcomentario event,
  Emitter<ComentarioState> emit,
) async {
  try {
    // Guardamos el estado actual
    final currentState = state;

    // Emitimos un estado de carga optimista mostrando la reacción
    if (currentState is ComentarioLoaded) {
      final comentarios = List<Comentario>.from(currentState.comentariosList);
      bool comentarioActualizado = false;

      // Buscamos el comentario que contiene el subcomentario
      for (int i = 0; i < comentarios.length && !comentarioActualizado; i++) {
        final comentario = comentarios[i];
        if (comentario.subcomentarios?.isNotEmpty == true) {
          final subcomentarios = List<Comentario>.from(comentario.subcomentarios!);
          
          // Buscamos el subcomentario específico
          for (int j = 0; j < subcomentarios.length; j++) {
            if (subcomentarios[j].id == event.subcomentarioId) {
              final subcomentario = subcomentarios[j];
              
              // Actualizamos el subcomentario optimistamente
              final subcomentarioActualizado = Comentario(
                id: subcomentario.id,
                noticiaId: subcomentario.noticiaId,
                texto: subcomentario.texto,
                autor: subcomentario.autor,
                fecha: subcomentario.fecha,
                likes: event.tipoReaccion == 'like' 
                    ? subcomentario.likes + 1 
                    : subcomentario.likes,
                dislikes: event.tipoReaccion == 'dislike' 
                    ? subcomentario.dislikes + 1 
                    : subcomentario.dislikes,
                subcomentarios: subcomentario.subcomentarios,
                isSubComentario: subcomentario.isSubComentario,
                idSubComentario: subcomentario.idSubComentario,
              );

              // Reemplazamos el subcomentario en la lista
              subcomentarios[j] = subcomentarioActualizado;
              
              // Actualizamos el comentario principal con los subcomentarios modificados
              comentarios[i] = comentario.copyWith(subcomentarios: subcomentarios);
              comentarioActualizado = true;
              break;
            }
          }
        }
      }

      if (comentarioActualizado) {
        emit(ComentarioLoaded(comentariosList: comentarios));
      }
    }

    // Llamamos al servicio de cache para persistir el cambio usando el método específico para subcomentarios
    await _cacheService.reaccionarSubcomentario(
      noticiaId: event.noticiaId,
      subcomentarioId: event.subcomentarioId,
      tipoReaccion: event.tipoReaccion,
    );

    // Recargamos los comentarios para asegurar los datos más recientes
    final comentariosActualizados = await _cacheService.getComentariosPorNoticia(event.noticiaId);
    emit(ComentarioLoaded(comentariosList: comentariosActualizados));
    
  } catch (e) {
    // Si ocurre un error, intentamos recargar los comentarios para restaurar el estado
    try {
      final comentarios = await _cacheService.getComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentariosList: comentarios));
    } catch (_) {
      // Si incluso la recarga falla, mostramos el error
      emit(
        ComentarioError(
          errorMessage: 'Error al agregar reacción al subcomentario. Intenta de nuevo: ${e.toString()}',
        ),
      );
    }
  }
}

}
