import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';
import 'package:afranco/data/comentario_repository.dart';
import 'package:afranco/domain/comentario.dart';

/// Servicio singleton para cachear comentarios de noticias
class ComentarioCacheService {
  // Instancia singleton private
  static final ComentarioCacheService _instance =
      ComentarioCacheService._internal();
    final Map<String, int> _conteoCache = {};

  // Constructor factory que retorna la misma instancia
  factory ComentarioCacheService() => _instance;

  // Constructor privado
  ComentarioCacheService._internal();

  // Inyectamos el repositorio de comentarios usando di
  final ComentarioRepository _comentarioRepository = di<ComentarioRepository>();

  // Cache de comentarios por noticia ID
  final Map<String, List<Comentario>> _comentariosPorNoticia = {};

  // Cache de números de comentarios por noticia ID
  final Map<String, int> _numeroComentariosPorNoticia = {};

  // Timestamp de la última actualización por noticia ID
  final Map<String, DateTime> _lastRefreshedByNoticiaId = {};

  // Tiempo máximo de validez de la cache en minutos
  final int _cacheValidityMinutes = 5;

  /// Retorna la lista de comentarios para una noticia específica
  /// Si no hay comentarios en cache o ha expirado, realiza una carga desde la API
  Future<List<Comentario>> getComentariosPorNoticia(String noticiaId) async {
    try {
      // Si no hay comentarios en cache o la cache ha expirado, obtener desde la API
      if (_needsRefresh(noticiaId)) {
        await refreshComentarios(noticiaId);
      }

      // Retorna una copia de la lista para evitar modificaciones externas
      return List<Comentario>.from(_comentariosPorNoticia[noticiaId] ?? []);
    } catch (e) {
      debugPrint('❌ Error al obtener comentarios desde cache: ${e.toString()}');
      // En caso de error, retornamos los datos en cache o lista vacía si no hay
      return List<Comentario>.from(_comentariosPorNoticia[noticiaId] ?? []);
    }
  }

  /// Refresca los comentarios desde la API para una noticia específica
  Future<void> refreshComentarios(String noticiaId) async {
    try {
      debugPrint('🔄 Refrescando comentarios para noticia: $noticiaId');
      final comentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(noticiaId);
      _comentariosPorNoticia[noticiaId] = comentarios;
      _lastRefreshedByNoticiaId[noticiaId] = DateTime.now();

      // Actualizamos también el número de comentarios
      _numeroComentariosPorNoticia[noticiaId] = comentarios.length;

      debugPrint(
        '✅ Comentarios actualizados: ${comentarios.length} items para noticia $noticiaId',
      );
    } catch (e) {
      debugPrint('❌ Error al refrescar comentarios: ${e.toString()}');
      // No modificamos cache si hay error para mantener datos anteriores
      rethrow;
    }
  }

  /// Obtiene el número de comentarios para una noticia específica
  /// Si no hay datos en cache o ha expirado, realiza una carga desde la API
  Future<int> getNumeroComentarios(String noticiaId) async {
    // Primero revisar el caché en memoria
    if (_conteoCache.containsKey(noticiaId)) {
      return _conteoCache[noticiaId]!;
    }

    final count = await _comentarioRepository.obtenerNumeroComentarios(
      noticiaId,
    );
    _conteoCache[noticiaId] = count;
    return count;
  }


  /// Agrega un comentario y actualiza la cache
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    await _comentarioRepository.agregarComentario(
      noticiaId,
      texto,
      autor,
      fecha,
    );

    // Refrescamos la cache después de agregar
    await refreshComentarios(noticiaId);
  }

  /// Agrega una reacción a un comentario y actualiza la cache
  Future<void> reaccionarComentario({
    required String noticiaId,
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    await _comentarioRepository.reaccionarComentario(
      comentarioId: comentarioId,
      tipoReaccion: tipoReaccion,
    );

    // Refrescamos la cache después de reaccionar
    await refreshComentarios(noticiaId);
  }

  /// Agrega un subcomentario y actualiza la cache
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String noticiaId,
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    final result = await _comentarioRepository.agregarSubcomentario(
      comentarioId: comentarioId,
      texto: texto,
      autor: autor,
    );

    // Refrescamos la cache si fue exitoso
    if (result['success'] == true) {
      await refreshComentarios(noticiaId);
    }

    return result;
  }

  /// Verifica si los comentarios para una noticia específica necesitan actualizarse
  bool _needsRefresh(String noticiaId) {
    // Si no hay datos en cache para esta noticia
    if (!_comentariosPorNoticia.containsKey(noticiaId)) {
      return true;
    }

    // Si no hay timestamp para esta noticia
    final lastRefreshed = _lastRefreshedByNoticiaId[noticiaId];
    if (lastRefreshed == null) {
      return true;
    }

    // Si el cache ha expirado
    final difference = DateTime.now().difference(lastRefreshed).inMinutes;
    return difference >= _cacheValidityMinutes;
  }

  /// Verifica si hay comentarios cacheados para una noticia específica
  bool hasCachedComentarios(String noticiaId) =>
      _comentariosPorNoticia.containsKey(noticiaId);

  /// Obtiene el timestamp de la última actualización para una noticia específica
  DateTime? getLastRefreshed(String noticiaId) =>
      _lastRefreshedByNoticiaId[noticiaId];

  /// Invalida la cache para una noticia específica
  void invalidateCache(String noticiaId) {
    _comentariosPorNoticia.remove(noticiaId);
    _numeroComentariosPorNoticia.remove(noticiaId);
    _lastRefreshedByNoticiaId.remove(noticiaId);
  }

  /// Limpia toda la cache de comentarios
  void clearAll() {
    _comentariosPorNoticia.clear();
    _numeroComentariosPorNoticia.clear();
    _lastRefreshedByNoticiaId.clear();
    debugPrint('🗑️ Cache de comentarios limpiado completamente');
  }
}
