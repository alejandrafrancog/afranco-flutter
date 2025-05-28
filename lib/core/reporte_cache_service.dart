import 'dart:async';

import 'package:afranco/domain/reporte.dart';
import 'package:flutter/foundation.dart';

/// Servicio para cachear reportes y minimizar llamadas a la API
class ReporteCacheService {
  static final ReporteCacheService _instance = ReporteCacheService._internal();
  final Map<String, int> _reportesCountCache = {};

  // Streams para notificar cambios
  final Map<String, StreamController<int>> _countStreamControllers = {};
  // Singleton pattern
  factory ReporteCacheService() {
    return _instance;
  }

  ReporteCacheService._internal();

  // Caché de reportes por noticiaId
  final Map<String, List<Reporte>> _reportesPorNoticiaCache = {};

  // Caché del total de reportes
  List<Reporte>? _todosLosReportes;

  // Tiempo de expiración de la caché (5 minutos)
  final Duration _cacheExpiration = const Duration(minutes: 5);

  // Timestamp para el último refresh de cada noticia
  final Map<String, DateTime> _lastRefreshByNoticiaId = {};

  // Timestamp para el último refresh global
  DateTime? _lastGlobalRefresh;

  /// Obtiene los reportes de una noticia específica, ya sea desde la caché o solicitándolos
  Future<List<Reporte>> getReportesPorNoticia(
    String noticiaId,
    Future<List<Reporte>> Function(String) fetchFromApi,
  ) async {
    // Verificar si el caché ha expirado para esta noticia
    final lastRefresh = _lastRefreshByNoticiaId[noticiaId];
    final now = DateTime.now();
    final isCacheExpired =
        lastRefresh == null || now.difference(lastRefresh) > _cacheExpiration;

    // Si no está en caché o ha expirado, cargar desde la API
    if (!_reportesPorNoticiaCache.containsKey(noticiaId) || isCacheExpired) {
      try {
        debugPrint('🔄 Cargando reportes para noticia $noticiaId desde API');
        final reportes = await fetchFromApi(noticiaId);
        _reportesPorNoticiaCache[noticiaId] = reportes;
        _lastRefreshByNoticiaId[noticiaId] = now;
        return reportes;
      } catch (e) {
        debugPrint('❌ Error cargando reportes desde API: $e');
        // Si ya tenemos datos en caché, usarlos aunque hayan expirado
        if (_reportesPorNoticiaCache.containsKey(noticiaId)) {
          debugPrint(
            '⚠️ Usando caché expirada para reportes de noticia $noticiaId',
          );
          return _reportesPorNoticiaCache[noticiaId]!;
        }
        // Si no hay caché, propagar el error
        rethrow;
      }
    } else {
      debugPrint('✅ Usando caché para reportes de noticia $noticiaId');
      return _reportesPorNoticiaCache[noticiaId]!;
    }
  }

  Stream<int> getReportesCountStream(String noticiaId) {
    // Crear controller si no existe
    if (!_countStreamControllers.containsKey(noticiaId)) {
      _countStreamControllers[noticiaId] = StreamController<int>.broadcast();

      // Emitir valor inicial si existe en caché
      if (_reportesCountCache.containsKey(noticiaId)) {
        _countStreamControllers[noticiaId]!.add(
          _reportesCountCache[noticiaId]!,
        );
      } else {
        _countStreamControllers[noticiaId]!.add(0);
      }
    }

    return _countStreamControllers[noticiaId]!.stream;
  }
  void addReporte(Reporte reporte) {
    final noticiaId = reporte.noticiaId;
    
    // Actualizar caché de reportes
    if (_reportesPorNoticiaCache.containsKey(noticiaId)) {
      _reportesPorNoticiaCache[noticiaId]!.add(reporte);
    } else {
      _reportesPorNoticiaCache[noticiaId] = [reporte];
    }
    
    // Actualizar contador
    final newCount = _reportesPorNoticiaCache[noticiaId]!.length;
    _reportesCountCache[noticiaId] = newCount;
    
    // Notificar cambio
    _notifyCountChanged(noticiaId, newCount);
  }
  
  // Método para remover reporte (llamado desde el BLoC)
  void removeReporte(String reporteId, String noticiaId) {
    // Remover de la lista de reportes
    if (_reportesPorNoticiaCache.containsKey(noticiaId)) {
      _reportesPorNoticiaCache[noticiaId]!.removeWhere((r) => r.id == reporteId);
      
      // Actualizar contador
      final newCount = _reportesPorNoticiaCache[noticiaId]!.length;
      _reportesCountCache[noticiaId] = newCount;
      
      // Notificar cambio
      _notifyCountChanged(noticiaId, newCount);
    }
  }
  
  // Método para invalidar caché de una noticia específica
  void invalidateNoticiaCache(String noticiaId) {
    _reportesPorNoticiaCache.remove(noticiaId);
    _reportesCountCache.remove(noticiaId);
  }
  
  // Método para invalidar toda la caché
  void invalidateAllCache() {
    _reportesPorNoticiaCache.clear();
    _reportesCountCache.clear();
    
    // Resetear todos los streams a 0
    for (final controller in _countStreamControllers.values) {
      controller.add(0);
    }
  }
  // Método para limpiar recursos
  void dispose() {
    for (final controller in _countStreamControllers.values) {
      controller.close();
    }
    _countStreamControllers.clear();
  }

  // NUEVO: Método privado para notificar cambios
  void _notifyCountChanged(String noticiaId, int newCount) {
    if (_countStreamControllers.containsKey(noticiaId)) {
      _countStreamControllers[noticiaId]!.add(newCount);
    }
  }

  /// Obtiene todos los reportes, ya sea desde la caché o solicitándolos
  Future<List<Reporte>> getTodosLosReportes(
    Future<List<Reporte>> Function() fetchFromApi,
  ) async {
    // Verificar si el caché global ha expirado
    final now = DateTime.now();
    final isCacheExpired =
        _lastGlobalRefresh == null ||
        now.difference(_lastGlobalRefresh!) > _cacheExpiration;

    // Si no está en caché o ha expirado, cargar desde la API
    if (_todosLosReportes == null || isCacheExpired) {
      try {
        debugPrint('🔄 Cargando todos los reportes desde API');
        final reportes = await fetchFromApi();
        _todosLosReportes = reportes;
        _lastGlobalRefresh = now;
        return reportes;
      } catch (e) {
        debugPrint('❌ Error cargando todos los reportes desde API: $e');
        // Si ya tenemos datos en caché, usarlos aunque hayan expirado
        if (_todosLosReportes != null) {
          debugPrint('⚠️ Usando caché global expirada para reportes');
          return _todosLosReportes!;
        }
        // Si no hay caché, propagar el error
        rethrow;
      }
    } else {
      debugPrint('✅ Usando caché global para reportes');
      return _todosLosReportes!;
    }
  }

  /// Obtiene el número de reportes para una noticia específica
  Future<int> getNumeroReportesPorNoticia(
    String noticiaId,
    Future<List<Reporte>> Function(String) fetchFromApi,
  ) async {
    final reportes = await getReportesPorNoticia(noticiaId, fetchFromApi);
    return reportes.length;
  }

  /// Agrega un reporte a la caché
  /*void addReporte(Reporte reporte) {
    // Actualizar caché por noticia
    invalidateNoticiaCache(reporte.noticiaId); // <-- Añadir
    _todosLosReportes = null;

    if (_reportesPorNoticiaCache.containsKey(reporte.noticiaId)) {
      final reportesNoticia = _reportesPorNoticiaCache[reporte.noticiaId]!;
      if (!reportesNoticia.any((r) => r.id == reporte.id)) {
        reportesNoticia.add(reporte);
      }
    } else {
      _reportesPorNoticiaCache[reporte.noticiaId] = [reporte];
    }

    // Actualizar caché global si existe
    if (_todosLosReportes != null) {
      if (!_todosLosReportes!.any((r) => r.id == reporte.id)) {
        _todosLosReportes!.add(reporte);
      }
    }

    debugPrint('✅ Reporte ${reporte.id} añadido a caché');
  }*/

  /// Actualiza un reporte en la caché
  void updateReporte(Reporte reporte) {
    // Actualizar en caché por noticia
    if (_reportesPorNoticiaCache.containsKey(reporte.noticiaId)) {
      final reportesNoticia = _reportesPorNoticiaCache[reporte.noticiaId]!;
      final index = reportesNoticia.indexWhere((r) => r.id == reporte.id);
      if (index != -1) {
        reportesNoticia[index] = reporte;
      }
    }

    // Actualizar en caché global si existe
    if (_todosLosReportes != null) {
      final index = _todosLosReportes!.indexWhere((r) => r.id == reporte.id);
      if (index != -1) {
        _todosLosReportes![index] = reporte;
      }
    }

    debugPrint('✅ Reporte ${reporte.id} actualizado en caché');
  }

  /// Elimina un reporte de la caché
  /*void removeReporte(String reporteId, String noticiaId) {
    // Eliminar de caché por noticia
    if (_reportesPorNoticiaCache.containsKey(noticiaId)) {
      _reportesPorNoticiaCache[noticiaId]!.removeWhere(
        (r) => r.id == reporteId,
      );
    }
    // Eliminar de caché global si existe
    if (_todosLosReportes != null) {
      _todosLosReportes!.removeWhere((r) => r.id == reporteId);
    }

    debugPrint('✅ Reporte $reporteId eliminado de caché');
  }

  /// Invalida la caché de una noticia específica
  void invalidateNoticiaCache(String noticiaId) {
    _reportesPorNoticiaCache.remove(noticiaId);
    _lastRefreshByNoticiaId.remove(noticiaId);
    debugPrint('🔄 Caché de reportes para noticia $noticiaId invalidada');
  }

  /// Invalida toda la caché de reportes
  void invalidateAllCache() {
    _reportesPorNoticiaCache.clear();
    _todosLosReportes = null;
    _lastRefreshByNoticiaId.clear();
    _lastGlobalRefresh = null;
    debugPrint('🔄 Caché de reportes completamente invalidada');
  }*/
}
