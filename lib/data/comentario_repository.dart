import 'package:flutter/foundation.dart';
import 'package:afranco/api/service/comentario_service.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:afranco/exceptions/api_exception.dart';

class ComentarioRepository {
  final ComentarioService _service = ComentarioService();

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    try {
      final comentarios = await _service.obtenerComentariosPorNoticia(
        noticiaId,
      );
      return comentarios;
    } catch (e) {
      if (e is ApiException) {
        rethrow; // Relanza la excepción para que la maneje el BLoC
      }
      debugPrint('Error inesperado al obtener comentarios: $e');
      throw ApiException(
        message: 'Error inesperado al obtener comentarios.',
        statusCode: 0,
      );
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    if (texto.isEmpty) {
      throw ApiException(
        message: 'El texto del comentario no puede estar vacío.',
        statusCode: 400,
      );
    }

    try {
      await _service.agregarComentario(noticiaId, texto, autor, fecha);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado al agregar comentario: $e');
      throw ApiException(
        message: 'Error inesperado al agregar comentario.',
        statusCode: null,
      );
    }
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final count = await _service.obtenerNumeroComentarios(noticiaId);
      return count;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error al obtener número de comentarios: $e');
      return 0; // En caso de error, retornamos 0 como valor seguro
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      await _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado al reaccionar al comentario: $e');
      throw ApiException(
        message: 'Error inesperado al reaccionar al comentario.',
        statusCode: null,
      );
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.',
      };
    }

    try {
      final resultado = await _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      );
      return resultado;
    } catch (e) {
      debugPrint('Error inesperado al agregar subcomentario: $e');
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}',
      };
    }
  }
}
