/*import 'package:flutter/foundation.dart';
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
*/
import 'package:afranco/api/service/comentario_service.dart';
import 'package:afranco/data/base_repository.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:afranco/core/secure_storage_service.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

/// Repositorio para gestionar operaciones relacionadas con los comentarios.
/// Utiliza caché para mejorar la eficiencia al obtener comentarios.
class ComentarioRepository extends BaseRepository {
  final _comentarioService = di<ComentarioService>();
  final _secureStorageService = di<SecureStorageService>();

  void validarEntidad(Comentario comentario) {
    validarNoVacio(comentario.texto, 'texto del comentario');
    validarNoVacio(comentario.autor, 'autor del comentario');
    validarNoVacio(comentario.noticiaId, 'ID de la noticia');
  }

  /// Método para validar un subcomentario
  void validarSubcomentario(Comentario subcomentario) {
    validarEntidad(subcomentario);
  }

  /// Obtiene todos los comentarios de una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');
      final comentarios = await _comentarioService.obtenerComentariosPorNoticia(
        noticiaId,
      );
      return comentarios;
    }, mensajeError: 'Error al obtener comentarios');
  }

  /// Agrega un nuevo comentario a una noticia
  Future<Comentario> agregarComentario(Comentario comentario) async {
    return manejarExcepcion(() async {
      validarEntidad(comentario);
      comentario = comentario.copyWith(
        autor: await _secureStorageService.getUserEmail(),
      );
      final response = await _comentarioService.agregarComentario(comentario);
      return response;
    }, mensajeError: 'Error al agregar comentario');
  }

  /// Registra una reacción (like o dislike) a un comentario
  Future<Comentario> reaccionarComentario(
    String comentarioId,
    String tipo,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(comentarioId, 'ID del comentario');
      Comentario response;
      if (comentarioId.contains('sub_')) {
        response = await _comentarioService.reaccionarSubComentario(
          subComentarioId: comentarioId,
          tipoReaccion: tipo,
        );
      } else {
        response = await _comentarioService.reaccionarComentarioPrincipal(
          comentarioId: comentarioId,
          tipoReaccion: tipo,
        );
      }
      return response;
    }, mensajeError: 'Error al registrar reacción');
  }

  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final count = await _comentarioService.obtenerNumeroComentarios(
        noticiaId,
      );
      return count;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error al obtener número de comentarios: $e');
      return 0; // En caso de error, retornamos 0 como valor seguro
    }
  }

  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<Comentario> agregarSubcomentario(Comentario subcomentario) async {
    return manejarExcepcion(() async {
      validarSubcomentario(subcomentario);
      final comentarioPadreId = subcomentario.idSubComentario!;
      //Asignar un ID único al subcomentario y autor al comentario
      subcomentario = subcomentario.copyWith(
        id:
            'sub_${DateTime.now().millisecondsSinceEpoch}_${subcomentario.texto.hashCode}',
        autor: await _secureStorageService.getUserEmail(),
      );
      final response = await _comentarioService.agregarSubcomentario(
        comentarioId: comentarioPadreId,
        subComentario: subcomentario,
      );
      return response;
    }, mensajeError: 'Error al agregar subcomentario');
  }

  /// Elimina todos los reportes asociados a una noticia
  Future<void> eliminarComentariosPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');
      await _comentarioService.eliminarComentariosPorNoticia(noticiaId);
    }, mensajeError: "Error al eliminar comentarios");
  }
}
