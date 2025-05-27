import 'package:afranco/domain/reporte.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_event.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_state.dart';
import 'package:afranco/data/reporte_repository.dart';
import 'package:afranco/core/reporte_cache_service.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository reporteRepository = di<ReporteRepository>();
  final ReporteCacheService reporteCacheService = di<ReporteCacheService>();
  List<Reporte>? _reporteCache;

  ReporteBloc() : super(ReporteInitial()) {
    on<ReporteInitEvent>(_onInit);
    on<ReporteCreateEvent>(_onCreateReporte);
    on<ReporteDeleteEvent>(_onDeleteReporte);
    on<ReporteGetByNoticiaEvent>(_onGetByNoticia);
    on<ReporteRefreshEvent>(_onRefreshReportes);
  }

  Future<void> _onInit(
    ReporteInitEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      if (_reporteCache != null) {
        emit(ReporteLoaded(_reporteCache!, DateTime.now()));
        return;
      }

      final reportes = await reporteRepository.obtenerReportes();
      _reporteCache = reportes;
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al cargar reportes: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

  Future<void> _onCreateReporte(
    ReporteCreateEvent event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      final reporte = await reporteRepository.crearReporte(
        noticiaId: event.noticiaId,
        motivo: event.motivo,
      );

      if (reporte != null) {
        // ACTUALIZAR EL CACHE SERVICE - esto actualizará automáticamente el stream
        reporteCacheService.addReporte(reporte);
        
        // Actualizar caché local del BLoC
        if (_reporteCache != null) {
          _reporteCache = [..._reporteCache!, reporte];
        }

        // Emitir estado de éxito con mensaje
        emit(ReporteLoadedWithMessage(
          reportes: _reporteCache ?? [reporte],
          message: 'Reporte creado exitosamente',
        ));
      }
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al crear reporte: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

  Future<void> _onDeleteReporte(
    ReporteDeleteEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      await reporteRepository.eliminarReporte(event.id);

      // Encontrar la noticia del reporte eliminado para actualizar caché
      String? noticiaId;
      if (_reporteCache != null) {
        final reporte = _reporteCache!.firstWhere(
          (r) => r.id == event.id,
          orElse: () => throw Exception('Reporte no encontrado'),
        );
        noticiaId = reporte.noticiaId;
      }

      // ACTUALIZAR EL CACHE SERVICE - esto actualizará automáticamente el stream
      if (noticiaId != null) {
        reporteCacheService.removeReporte(event.id, noticiaId);
      }

      emit(ReporteDeleted(event.id));

      // Recargar la lista después de eliminar
      final reportes = await reporteRepository.obtenerReportes();
      _reporteCache = reportes;
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al eliminar reporte: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

  Future<void> _onGetByNoticia(
    ReporteGetByNoticiaEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportesPorNoticia(
        event.noticiaId,
      );
      emit(ReportesPorNoticiaLoaded(reportes, event.noticiaId));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al obtener reportes por noticia: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

  Future<void> _onRefreshReportes(
    ReporteRefreshEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
    try {
      // Forzar recarga ignorando la caché
      _reporteCache = null;
      reporteCacheService.invalidateAllCache();

      final reportes = await reporteRepository.obtenerReportes();
      _reporteCache = reportes;
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al refrescar reportes: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }
}