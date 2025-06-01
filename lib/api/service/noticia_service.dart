import 'dart:async';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/api/service/comentario_service.dart'; // Agregar esta importación
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaService extends BaseService {
  final String _baseUrl = ApiConstants.urlNoticias;
  final ComentarioService _comentarioService =
      di<ComentarioService>(); // Instancia del servicio de comentarios
  NoticiaService() : super();


  /// Crea una nueva noticia
  Future<void> createNoticia(Noticia noticia) async {
    debugPrint('➕ Creando nueva noticia');

    await post(
      _baseUrl,
      data: {
        'categoriaId': noticia.categoriaId,
        'titulo': noticia.titulo,
        'descripcion': noticia.descripcion,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
        'contadorReportes': noticia.contadorReportes,
        'contadorComentarios': noticia.contadorComentarios,
      },
      errorMessage: NoticiaConstants.errorCrearNoticia,
      requireAuthToken: true,
    );

    debugPrint('✅ Noticia creada con éxito');
  }

  Future<Noticia> getNoticiaById(String id) async {
    debugPrint('🔍 Obteniendo noticia con ID: $id');

    final data = await get<Map<String, dynamic>>(
      '$_baseUrl/$id',
      errorMessage: NoticiaConstants.errorObtenerNoticia,
    );

    return NoticiaMapper.fromMap(data);
  }

  /// Actualiza una noticia existente
  Future<void> updateNoticia(
    Noticia noticia, {
    String? titulo,
    String? categoriaId,
    String? descripcion,
    String? fuente,
  }) async {
    debugPrint('🔄 Actualizando noticia con ID: ${noticia.id}');

    await put(
      '$_baseUrl/${noticia.id}',
      data: {
        'titulo': titulo ?? noticia.titulo,
        'categoriaId': categoriaId ?? noticia.categoriaId,
        'descripcion': descripcion ?? noticia.descripcion,
        'fuente': fuente ?? noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
        'contadorReportes': noticia.contadorReportes,
        'contadorComentarios': noticia.contadorComentarios,
      },
      errorMessage: NoticiaConstants.errorActualizarNoticia,
      requireAuthToken: true,
    );

    debugPrint('✅ Noticia actualizada con éxito');
  }

  /// Obtiene todas las noticias tecnológicas
  Future<List<Noticia>> getTechNews({
    required int page,
    List<String> categoriasSeleccionadas = const [],
  }) async {
    debugPrint('📋 Obteniendo noticias de tecnología');

    final data = await get<List<dynamic>>(
      _baseUrl,
      errorMessage: NoticiaConstants.errorObtenerNoticiasTecno,
    );

    return data.map((json) => NoticiaMapper.fromMap(json)).toList();
  }

  /// Elimina una noticia por su ID y todos sus comentarios asociados
  Future<void> eliminarNoticia(String id) async {
    debugPrint('🗑️ Eliminando noticia con ID: $id');

    try {
      // 1. Primero eliminar todos los comentarios asociados a la noticia
      debugPrint('🗑️ Eliminando comentarios de la noticia...');
      await _comentarioService.eliminarComentariosPorNoticia(id);
      debugPrint('✅ Comentarios eliminados correctamente');

      // 2. Luego eliminar la noticia
      await delete(
        '$_baseUrl/$id',
        errorMessage: NoticiaConstants.errorEliminarNoticia,
        requireAuthToken: true,
      );

      debugPrint('✅ Noticia eliminada correctamente');
    } catch (e) {
      debugPrint('❌ Error al eliminar la noticia: $e');
      rethrow;
    }
  }

  /// Actualiza una noticia y retorna el objeto actualizado
  Future<Noticia> actualizarNoticia(Noticia noticia) async {
    debugPrint('🔄 Actualizando noticia completa con ID: ${noticia.id}');

    final data = await put(
      '$_baseUrl/${noticia.id}',
      data: noticia.toJson(),
      errorMessage: NoticiaConstants.errorActualizarNoticia,
      requireAuthToken: true,
    );

    debugPrint('✅ Noticia actualizada con éxito');
    return NoticiaMapper.fromMap(data);
  }

  /// Elimina una noticia y todos sus comentarios asociados, retorna la respuesta completa
  Future<void> deleteNoticia(String id) async {
    debugPrint('🗑️ Eliminando noticia con ID: $id');

    try {
      // 1. Primero eliminar todos los comentarios asociados a la noticia
      debugPrint('🗑️ Eliminando comentarios de la noticia...');
      await _comentarioService.eliminarComentariosPorNoticia(id);
      debugPrint('✅ Comentarios eliminados correctamente');

      // 2. Luego eliminar la noticia
      await delete(
        '$_baseUrl/$id',
        errorMessage: NoticiaConstants.errorEliminarNoticia,
        requireAuthToken: true,
      );

      debugPrint('✅ Noticia eliminada correctamente');
    } catch (e) {
      debugPrint('❌ Error al eliminar la noticia: $e');
      rethrow;
    }
  }
}
