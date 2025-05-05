import 'dart:async';
import 'package:afranco/bloc/noticia_bloc/noticia_event.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/api/service/noticia_repository.dart';
import 'package:afranco/constants/constants.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository noticiaRepository = di<NoticiaRepository>();
  int _currentPage = 1;
  final bool _ordenarPorFecha = true;

  NoticiaBloc() : super(NoticiaState()) {
    on<NoticiaCargadaEvent>(_onCargarNoticias);
    on<NoticiaCargarMasEvent>(_onCargarMasNoticias);
    on<NoticiaRecargarEvent>(_onRecargarNoticias);
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
}
