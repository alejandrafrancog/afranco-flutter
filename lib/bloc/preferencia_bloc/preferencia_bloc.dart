//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_event.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_state.dart';
import 'package:afranco/data/preferencia_repository.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaBloc extends Bloc<PreferenciaEvent, PreferenciaState> {
  final PreferenciaRepository _preferenciasRepository =
      di<PreferenciaRepository>(); // Obtenemos el repositorio del locator

  PreferenciaBloc() : super(const PreferenciaLoading()) {
    on<CargarPreferencias>(_onCargarPreferencias);
    on<CambiarCategoria>(_onCambiarCategoria);
    on<CambiarMostrarFavoritos>(_onCambiarMostrarFavoritos);
    on<SavePreferencias>(_onSavePreferencias);
    on<BuscarPorPalabraClave>(_onBuscarPorPalabraClave);
    on<ReiniciarFiltros>(_onReiniciarFiltros);
  }

  Future<void> _onCargarPreferencias(
    CargarPreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    // ✅ Emitir loading solo si no estamos ya en un estado válido
    if (state is PreferenciaLoading) {
      emit(const PreferenciaLoading());
    }

    try {
      final categoriasSeleccionadas =
          await _preferenciasRepository.obtenerCategoriasSeleccionadas();

      // ✅ Crear el estado completo después de cargar
      emit(
        PreferenciaState(
          categoriasSeleccionadas: categoriasSeleccionadas,
          mostrarFavoritos: false,
          palabraClave: '',
          fechaDesde: null,
          fechaHasta: null,
          ordenarPor: 'fecha',
          ascendente: false,
        ),
      );
    } catch (e) {
      emit(PreferenciaError('Error al cargar preferencias: ${e.toString()}'));
    }
  }

  void _onCambiarCategoria(
    CambiarCategoria event,
    Emitter<PreferenciaState> emit,
  ) async {
    // ✅ Prevenir cambios mientras está cargando
    if (state is PreferenciaLoading) {
      return;
    }

    try {
      final List<String> categoriasActualizadas = [
        ...state.categoriasSeleccionadas,
      ];

      if (event.seleccionada) {
        if (!categoriasActualizadas.contains(event.categoria)) {
          categoriasActualizadas.add(event.categoria);
        }
      } else {
        categoriasActualizadas.remove(event.categoria);
      }

      emit(state.copyWith(categoriasSeleccionadas: categoriasActualizadas));

      try {
        if (event.seleccionada) {
          await _preferenciasRepository.agregarCategoriaFiltro(event.categoria);
        } else {
          await _preferenciasRepository.eliminarCategoriaFiltro(
            event.categoria,
          );
        }
      } catch (e) {
        debugPrint('Error al persistir cambio de categoría: $e');
      }
    } catch (e) {
      emit(PreferenciaError('Error al cambiar categoría: ${e.toString()}'));
    }
  }

  void _onCambiarMostrarFavoritos(
    CambiarMostrarFavoritos event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(
      mostrarFavoritos: event.mostrarFavoritos,
    );
    emit(nuevoEstado);
  }

  void _onBuscarPorPalabraClave(
    BuscarPorPalabraClave event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(palabraClave: event.palabraClave);
    emit(nuevoEstado);
  }

  void _onReiniciarFiltros(
    ReiniciarFiltros event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Limpiar las categorías seleccionadas usando el método del repositorio
      await _preferenciasRepository.limpiarFiltrosCategorias();

      // Emitir un estado inicial
      const estadoInicial = PreferenciaState();
      emit(estadoInicial);
    } catch (e) {
      emit(PreferenciaError('Error al reiniciar filtros: ${e.toString()}'));
    }
  }

  Future<void> _onSavePreferencias(
    SavePreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Más eficiente: guardar todas las categorías a la vez
      await _preferenciasRepository.guardarCategoriasSeleccionadas(
        event.categoriasSeleccionadas,
      );

      // Emitir el estado actualizado
      emit(
        state.copyWith(categoriasSeleccionadas: event.categoriasSeleccionadas),
      );
    } catch (e) {
      emit(PreferenciaError('Error al guardar preferencias: ${e.toString()}'));
    }
  }
}
