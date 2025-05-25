import 'dart:convert';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:flutter/foundation.dart';

class ComentarioService extends BaseService {
  ComentarioService() : super();

  Future<void> _verificarNoticiaExiste(String noticiaId) async {
    try {
      await get(
        '${ApiConstants.urlNoticias}/$noticiaId',
        requireAuthToken: false,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        throw ApiException(
          message: ApiConstants.errorNotFound,
          statusCode: 404,
        );
      }
      rethrow;
    }
  }

  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    try {
      debugPrint('🔍 Obteniendo comentarios para noticia: $noticiaId');

      // Use query parameters to filter on the backend
      final data = await get(
        ApiConstants.comentariosUrl,
        queryParameters: {'noticiaId': noticiaId},
        requireAuthToken: false,
      );

      if (data is! List) {
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException(
          message: 'Formato de respuesta inválido',
          statusCode: 500,
        );
      }

      final comentarios =
          data.map((json) {
            if (json['subcomentarios'] != null) {
              json['subcomentarios'] = _parsearSubcomentarios(
                json['subcomentarios'],
              );
            }
            return ComentarioMapper.fromMap(json);
          }).toList();

      debugPrint('✅ ${comentarios.length} comentarios obtenidos');
      return comentarios;
    } on ApiException {
      debugPrint('❌ Error de API obteniendo comentarios');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error inesperado: $e');
      throw ApiException(
        message: 'Error obteniendo comentarios',
        statusCode: 500,
      );
    }
  }

  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    await _verificarNoticiaExiste(noticiaId);

    final nuevoComentario = Comentario(
      id: '',
      noticiaId: noticiaId,
      texto: texto,
      fecha: DateTime.now().toIso8601String(),
      autor: 'Usuario Anónimo',
      likes: 0,
      dislikes: 0,
      subcomentarios: [],
      isSubComentario: false,
    );

    try {
      await post(
        ApiConstants.comentariosUrl,
        data: nuevoComentario.toMap(),
        requireAuthToken: true,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error agregando comentario: $e');
      throw ApiException(
        message: 'Error agregando comentario',
        statusCode: 500,
      );
    }
  }

  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      debugPrint(
        '🔢 Obteniendo número de comentarios para noticia: $noticiaId',
      );

      final data = await get(
        ApiConstants.comentariosUrl,
        queryParameters: {'noticiaId': noticiaId},
        requireAuthToken: false,
      );

      if (data is! List) {
        debugPrint('❌ La respuesta no es una lista: $data');
        return 0;
      }

      int total = 0;

      for (final comentario in data) {
        total += 1; // Contar el comentario principal

        final sub = _parsearSubcomentarios(comentario['subcomentarios']);
        total += sub.length; // Contar los subcomentarios
      }

      debugPrint('✅ Total de comentarios (incluyendo subcomentarios): $total');
      return total;
    } on ApiException {
      debugPrint('❌ Error de API obteniendo número de comentarios');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error contando comentarios: $e');
      return 0;
    }
  }

  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      final data = await get(
        ApiConstants.comentariosUrl,
        requireAuthToken: false,
      );
      final comentarios = data as List;
      bool encontrado = false;

      for (final comentario in comentarios) {
        if (comentario['id'] == comentarioId) {
          final actualizado = _aplicarReaccion(comentario, tipoReaccion);
          await put(
            '${ApiConstants.comentariosUrl}/$comentarioId',
            data: actualizado,
            requireAuthToken: true,
          );
          encontrado = true;
          break;
        }

        final subcomentarios = _parsearSubcomentarios(
          comentario['subcomentarios'],
        );
        for (final sub in subcomentarios) {
          if (sub['id'] == comentarioId) {
            final subActualizado = _aplicarReaccion(sub, tipoReaccion);
            final comentarioActualizado = {
              ...comentario,
              'subcomentarios':
                  subcomentarios
                      .map((s) => s == sub ? subActualizado : s)
                      .toList(),
            };

            await put(
              '${ApiConstants.comentariosUrl}/${comentario['id']}',
              data: comentarioActualizado,
              requireAuthToken: true,
            );
            encontrado = true;
            break;
          }
        }
        if (encontrado) break;
      }

      if (!encontrado) {
        throw ApiException(
          message: 'Comentario no encontrado',
          statusCode: 404,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error en reacción: $e');
      throw ApiException(message: 'Error procesando reacción', statusCode: 500);
    }
  }

  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    try {
      final data = await get(
        '${ApiConstants.comentariosUrl}/$comentarioId',
        requireAuthToken: false,
      );
      final comentarioData = data as Map<String, dynamic>;

      if (comentarioData['isSubComentario'] == true) {
        return {
          'success': false,
          'message':
              'No se pueden añadir subcomentarios a otros subcomentarios',
        };
      }
      String subId =
          'sub_${DateTime.now().millisecondsSinceEpoch}_${texto.hashCode}';
      final nuevoSubcomentario = Comentario(
        id: subId,
        noticiaId: comentarioData['noticiaId'],
        texto: texto,
        fecha: DateTime.now().toIso8601String(),
        autor: autor,
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: true,
        idSubComentario: subId,
      );

      final subcomentariosActuales = _parsearSubcomentarios(
        comentarioData['subcomentarios'],
      );
      subcomentariosActuales.add(nuevoSubcomentario.toMap());

      await put(
        '${ApiConstants.comentariosUrl}/$comentarioId',
        data: {...comentarioData, 'subcomentarios': subcomentariosActuales},
        requireAuthToken: true,
      );

      return {
        'success': true,
        'message': 'Subcomentario agregado correctamente',
      };
    } on ApiException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: ${e.toString()}'};
    }
  }

  List<dynamic> _parsearSubcomentarios(dynamic subcomentarios) {
    if (subcomentarios is String) {
      try {
        return jsonDecode(subcomentarios) as List<dynamic>;
      } catch (e) {
        return [];
      }
    }
    return List<dynamic>.from(subcomentarios ?? []);
  }

  Map<String, dynamic> _aplicarReaccion(
    Map<String, dynamic> comentario,
    String tipoReaccion,
  ) {
    final clave = tipoReaccion == 'like' ? 'likes' : 'dislikes';
    return {...comentario, clave: (comentario[clave] ?? 0) + 1};
  }
}
