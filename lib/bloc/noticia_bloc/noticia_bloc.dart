import 'dart:async';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_state.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/data/preferencia_repository.dart'; 
import 'package:afranco/constants/constants.dart';
import 'package:watch_it/watch_it.dart';
import 'package:afranco/core/noticia_cache_service.dart';
import 'package:flutter/foundation.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository noticiaRepository = di<NoticiaRepository>();
  final PreferenciaRepository _preferenciaRepository = di<PreferenciaRepository>(); // ✅ Añadir repositorio de preferencias
  final NoticiaCacheService _cacheService = NoticiaCacheService();
  
  int _currentPage = 1;
  final bool _ordenarPorFecha = true;
  List<String> _categoriasActivas = []; 

  NoticiaBloc() : super(const NoticiaState()) {
    on<NoticiaCargadaEvent>(_onCargarNoticias);
    on<NoticiaCargarMasEvent>(_onCargarMasNoticias);
    on<NoticiaRecargarEvent>(_onRecargarNoticias);
    on<FilterNoticiasByPreferencias>(_onFilterNoticiasByPreferencias);
    on<NoticiaCreatedEvent>(_onNoticiaCreated);
    on<NoticiaEditedEvent>(_onNoticiaEdited);
    on<NoticiaDeletedEvent>(_onNoticiaDeleted);
    on<CargarNoticiasConPreferenciasEvent>(_onCargarNoticiasConPreferencias); // Nuevo evento
  }

  // ✅ Nuevo handler para cargar noticias con preferencias automáticamente
  Future<void> _onCargarNoticiasConPreferencias(
    CargarNoticiasConPreferenciasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      debugPrint('🔄 Cargando noticias con preferencias del usuario');
      
      // Obtener preferencias del usuario
      final categoriasSeleccionadas = await _preferenciaRepository.obtenerCategoriasSeleccionadas();
      _categoriasActivas = categoriasSeleccionadas;
      
      debugPrint('📋 Categorías encontradas: $_categoriasActivas');
      
      if (_categoriasActivas.isEmpty) {
        // Si no hay preferencias, cargar todas las noticias
        debugPrint('📰 No hay preferencias, cargando todas las noticias');
        await _cargarNoticias(emit, resetear: true);
      } else {
        // Si hay preferencias, aplicar filtro automáticamente
        debugPrint('🎯 Aplicando filtro automático con ${_categoriasActivas.length} categorías');
        await _aplicarFiltroPreferencias(_categoriasActivas, emit);
      }
    } catch (e) {
      debugPrint('❌ Error al cargar preferencias: $e');
      // En caso de error, cargar todas las noticias
      await _cargarNoticias(emit, resetear: true);
    }
  }

  void _onNoticiaCreated(
    NoticiaCreatedEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // ✅ Recargar respetando filtros activos
      if (_categoriasActivas.isNotEmpty) {
        await _aplicarFiltroPreferencias(_categoriasActivas, emit);
      } else {
        final noticias = await noticiaRepository.obtenerNoticias();
        emit(NoticiasLoadedAfterCreate(noticias, DateTime.now()));
      }
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

  void _onNoticiaEdited(
    NoticiaEditedEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // ✅ Recargar respetando filtros activos
      if (_categoriasActivas.isNotEmpty) {
        await _aplicarFiltroPreferencias(_categoriasActivas, emit);
      } else {
        final noticias = await noticiaRepository.obtenerNoticias();
        emit(NoticiasLoadedAfterEdit(noticias, DateTime.now()));
      }
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

  void _onNoticiaDeleted(
    NoticiaDeletedEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // ✅ Recargar respetando filtros activos
      if (_categoriasActivas.isNotEmpty) {
        await _aplicarFiltroPreferencias(_categoriasActivas, emit);
      } else {
        final noticias = await noticiaRepository.obtenerNoticias();
        emit(NoticiasLoadedAfterDelete(noticias, DateTime.now()));
      }
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
    // Al recargar, mantener filtros activos
    if (_categoriasActivas.isNotEmpty) {
      await _aplicarFiltroPreferencias(_categoriasActivas, emit);
    } else {
      await _cargarNoticias(emit, resetear: true);
    }
  }

  Future<void> _cargarNoticias(
    Emitter<NoticiaState> emit, {
    bool resetear = false,
  }) async {
    try {
      if (resetear) {
        _currentPage = 1;
        emit(
          const NoticiaLoadingState(
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
    // ✅ Actualizar categorías activas
    _categoriasActivas = event.categoriasIds;
    await _aplicarFiltroPreferencias(event.categoriasIds, emit);
  }

  // ✅ Método centralizado para aplicar filtros de preferencias
  Future<void> _aplicarFiltroPreferencias(
    List<String> categoriasIds,
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

      debugPrint('🎯 Aplicando filtro con categorías: $categoriasIds');

      final allNoticias = await noticiaRepository.obtenerNoticias();

      // Actualizar caché con todas las noticias obtenidas
      for (final noticia in allNoticias) {
        await _cacheService.updateNoticia(noticia);
      }

      List<Noticia> filteredNoticias;
      
      if (categoriasIds.isEmpty) {
        // Si no hay categorías seleccionadas, mostrar todas
        filteredNoticias = allNoticias;
        debugPrint('📰 Mostrando todas las noticias: ${filteredNoticias.length}');
      } else {
        // Filtrar por categorías seleccionadas
        filteredNoticias = allNoticias
            .where((noticia) => categoriasIds.contains(noticia.categoriaId))
            .toList();
        debugPrint('📋 Noticias filtradas: ${filteredNoticias.length} de ${allNoticias.length}');
      }

      emit(
        state.copyWith(
          noticias: filteredNoticias,
          tieneMas: false, // Los filtros no usan paginación
          ultimaActualizacion: DateTime.now(),
          isLoading: false,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error al aplicar filtro: $e');
      emit(
        NoticiaErrorState(
          error: e,
          noticias: const [],
          tieneMas: false,
          ultimaActualizacion: DateTime.now(),
        ),
      );
    }
  }

  // ✅ Getter para saber si hay filtros activos
  bool get tienesFiltrosActivos => _categoriasActivas.isNotEmpty;
  
  // ✅ Getter para obtener categorías activas
  List<String> get categoriasActivas => List.unmodifiable(_categoriasActivas);
}