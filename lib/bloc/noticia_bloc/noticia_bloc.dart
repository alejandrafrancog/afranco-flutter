import 'dart:async';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/constants/constants.dart';
import 'package:watch_it/watch_it.dart';
import 'package:afranco/core/noticia_cache_service.dart'; // Asegúrate de importar el servicio

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository noticiaRepository = di<NoticiaRepository>();
  final NoticiaCacheService _cacheService =
      NoticiaCacheService(); // Instancia del caché
  int _currentPage = 1;
  final bool _ordenarPorFecha = true;

  NoticiaBloc() : super(NoticiaState()) {
    on<NoticiaCargadaEvent>(_onCargarNoticias);
    on<NoticiaCargarMasEvent>(_onCargarMasNoticias);
    on<NoticiaRecargarEvent>(_onRecargarNoticias);
    on<FilterNoticiasByPreferencias>(_onFilterNoticiasByPreferencias);
    on<NoticiaCreatedEvent>(_onNoticiaCreated);
    on<NoticiaEditedEvent>(_onNoticiaEdited);
    on<NoticiaDeletedEvent>(_onNoticiaDeleted);
  }
  void _onNoticiaCreated(
    NoticiaCreatedEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Recargar las noticias desde el repositorio
      final noticias = await noticiaRepository.obtenerNoticias();

      emit(NoticiasLoadedAfterCreate(noticias, DateTime.now()));
    } catch (error) {
      emit(
        NoticiaErrorState(
          error: error,
          noticias: state.noticias,
          tieneMas: state.tieneMas,
          ultimaActualizacion: state.ultimaActualizacion,
        ),
      );
    }
  }

  // Handler para edición de noticia
  void _onNoticiaEdited(
    NoticiaEditedEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Recargar las noticias desde el repositorio
      final noticias = await noticiaRepository.obtenerNoticias();

      emit(NoticiasLoadedAfterEdit(noticias, DateTime.now()));
    } catch (error) {
      emit(
        NoticiaErrorState(
          error: error,
          noticias: state.noticias,
          tieneMas: state.tieneMas,
          ultimaActualizacion: state.ultimaActualizacion,
        ),
      );
    }
  }

  // Handler para eliminación de noticia
  void _onNoticiaDeleted(
    NoticiaDeletedEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Recargar las noticias desde el repositorio
      final noticias = await noticiaRepository.obtenerNoticias();

      emit(NoticiasLoadedAfterDelete(noticias, DateTime.now()));
    } catch (error) {
      emit(
        NoticiaErrorState(
          error: error,
          noticias: state.noticias,
          tieneMas: state.tieneMas,
          ultimaActualizacion: state.ultimaActualizacion,
        ),
      );
    }
  }

  Future<void> _onCargarNoticias(
    NoticiaCargadaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    await _cargarNoticias(emit, resetear: true);
  }

  Future<void> _onCargarMasNoticias(
    NoticiaCargarMasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    if (state.isLoading || !state.tieneMas) return;
    await _cargarNoticias(emit);
  }

  Future<void> _onRecargarNoticias(
    NoticiaRecargarEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    await _cargarNoticias(emit, resetear: true);
  }

  Future<void> _cargarNoticias(
    Emitter<NoticiaState> emit, {
    bool resetear = false,
  }) async {
    try {
      if (resetear) {
        _currentPage = 1;
        emit(
          NoticiaLoadingState(
            noticias: [],
            tieneMas: true,
            ultimaActualizacion: null,
          ),
        );
      } else {
        emit(
          NoticiaLoadingState(
            noticias: state.noticias,
            tieneMas: state.tieneMas,
            ultimaActualizacion: state.ultimaActualizacion,
          ),
        );
      }

      final nuevasNoticias = await noticiaRepository
          .obtenerNoticiasPaginadas(
            numeroPagina: _currentPage,
            ordenarPorFecha: _ordenarPorFecha,
          )
          .timeout(const Duration(seconds: 15));

      // Actualizar caché con las nuevas noticias
      for (final noticia in nuevasNoticias) {
        await _cacheService.updateNoticia(noticia);
      }

      final tieneMas = nuevasNoticias.length >= NoticiaConstants.pageSize;

      emit(
        state.copyWith(
          noticias:
              resetear
                  ? nuevasNoticias
                  : [...state.noticias, ...nuevasNoticias],
          tieneMas: tieneMas,
          ultimaActualizacion: DateTime.now(),
          isLoading: false,
        ),
      );

      if (!resetear && tieneMas) {
        _currentPage++;
      } else if (resetear) {
        _currentPage = 2;
      }
    } catch (e) {
      emit(
        NoticiaErrorState(
          error: e,
          noticias: state.noticias,
          tieneMas: state.tieneMas,
          ultimaActualizacion: state.ultimaActualizacion,
        ),
      );
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferencias event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(
        const NoticiaLoadingState(
          noticias: [],
          tieneMas: true,
          ultimaActualizacion: null,
        ),
      );

      final allNoticias = await noticiaRepository.obtenerNoticias();

      // Actualizar caché con todas las noticias obtenidas
      for (final noticia in allNoticias) {
        await _cacheService.updateNoticia(noticia);
      }

      final filteredNoticias =
          allNoticias
              .where(
                (noticia) => event.categoriasIds.contains(noticia.categoriaId),
              )
              .toList();

      emit(
        state.copyWith(
          noticias: filteredNoticias,
          tieneMas: false,
          ultimaActualizacion: DateTime.now(),
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        NoticiaErrorState(
          error: e,
          noticias: [],
          tieneMas: false,
          ultimaActualizacion: DateTime.now(),
        ),
      );
    }
  }
}
