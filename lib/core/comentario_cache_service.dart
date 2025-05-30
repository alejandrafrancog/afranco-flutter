import 'package:afranco/api/service/comentario_service.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';
import 'package:afranco/data/comentario_repository.dart';
import 'package:afranco/domain/comentario.dart';

/// Servicio singleton para cachear comentarios de noticias
class ComentarioCacheService {
  // Instancia singleton private
  static final ComentarioCacheService _instance =
      ComentarioCacheService._internal();
  ComentarioService get _service => di<ComentarioService>();
  // Lazy initialization del repositorio de comentarios
  ComentarioRepository? _comentarioRepository;

  // Getter para obtener el repositorio con lazy initialization
  ComentarioRepository get _repository {
    _comentarioRepository ??= di<ComentarioRepository>();
    return _comentarioRepository!;
  }

  // Cache de comentarios por noticia ID
  final Map<String, List<Comentario>> _comentariosPorNoticia = {};

  // Cache de números de comentarios por noticia ID
  final Map<String, int> _numeroComentariosPorNoticia = {};

  // Cache de conteo de comentarios por noticia ID
  final Map<String, int> _conteoCache = {};

  // Timestamp de la última actualización por noticia ID
  final Map<String, DateTime> _lastRefreshedByNoticiaId = {};

  // Constructor factory que retorna la misma instancia
  factory ComentarioCacheService() => _instance;

  // Constructor privado
  ComentarioCacheService._internal();

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
      final comentarios = await _repository.obtenerComentariosPorNoticia(
        noticiaId,
      );
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

    final count = await _repository.obtenerNumeroComentarios(noticiaId);
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
    // Crear objeto Comentario con los datos proporcionados
    final comentario = Comentario(
      id: '', // Se asignará en el backend
      noticiaId: noticiaId,
      texto: texto,
      autor:
          autor, // Se sobrescribirá en el repositorio con el email del usuario
      fecha: fecha,
      likes: 0,
      dislikes: 0,
      subcomentarios: [],
      isSubComentario: false,
      
    );

    await _repository.agregarComentario(comentario);

    // Refrescamos la cache después de agregar
    await refreshComentarios(noticiaId);
  }

  /// Agrega una reacción a un comentario y actualiza la cache
  Future<void> reaccionarComentario({
    required String noticiaId,
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    await _repository.reaccionarComentario(comentarioId, tipoReaccion);

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
    try {
      // Crear objeto Comentario para el subcomentario
      final subcomentario = Comentario(
        id: '', // Se asignará automáticamente en el repositorio
        noticiaId: noticiaId,
        texto: texto,
        autor:
            autor, // Se sobrescribirá en el repositorio con el email del usuario
        fecha: DateTime.now().toIso8601String(),
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: true,
        idSubComentario: comentarioId, // ID del comentario padre
      );

      final result = await _repository.agregarSubcomentario(subcomentario);

      // Refrescamos la cache después de agregar el subcomentario
      await refreshComentarios(noticiaId);

      return {
        'success': true,
        'message': 'Subcomentario agregado correctamente',
        'data': result,
      };
    } catch (e) {
      debugPrint('❌ Error al agregar subcomentario: ${e.toString()}');
      return {
        'success': false,
        'message': 'Error al agregar subcomentario: ${e.toString()}',
      };
    }
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
    _conteoCache.remove(noticiaId);
  }

  Future<void> reaccionarSubcomentario({
    required String noticiaId,
    required String subcomentarioId,
    required String tipoReaccion,
  }) async {
    try {
      // Llamamos al servicio para reaccionar al subcomentario
      await _service.reaccionarSubComentario(
        subComentarioId: subcomentarioId,
        tipoReaccion: tipoReaccion,
      );

      // Invalidamos la cache para que se actualice con los datos más recientes
      invalidateCache(noticiaId);
    } catch (e) {
      debugPrint('❌ Error al reaccionar al subcomentario: $e');
      rethrow;
    }
  }

  /// Limpia toda la cache de comentarios
  void clearAll() {
    _comentariosPorNoticia.clear();
    _numeroComentariosPorNoticia.clear();
    _lastRefreshedByNoticiaId.clear();
    _conteoCache.clear();
    debugPrint('🗑️ Cache de comentarios limpiado completamente');
  }
}
