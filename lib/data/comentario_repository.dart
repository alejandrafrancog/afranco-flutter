
import 'package:afranco/api/service/comentario_service.dart';
import 'package:afranco/constants/constants.dart';
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
    validarNoVacio(comentario.noticiaId, NoticiaConstants.idNoticia);
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
      validarNoVacio(noticiaId, NoticiaConstants.idNoticia);
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
      validarNoVacio(noticiaId, NoticiaConstants.idNoticia);
      await _comentarioService.eliminarComentariosPorNoticia(noticiaId);
    }, mensajeError: "Error al eliminar comentarios");
  }
}
