import 'dart:convert';

import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:dio/dio.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter/material.dart';

class ComentarioService {
  final Dio dio = Dio();

  Future<void> _verificarNoticiaExiste(String noticiaId) async {
    try {
      final response = await dio.get('${ApiConstants.urlNoticias}/$noticiaId');
      if (response.statusCode != 200) {
        throw ApiException(
          message: ApiConstants.errorNotFound,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          message: ApiConstants.errorTimeout,
          statusCode: e.response?.statusCode,
        );
      } else if (e.response?.statusCode == 404) {
        throw ApiException(
          message: ApiConstants.errorNotFound,
          statusCode: 404,
        );
      } else {
        throw ApiException(
          message: ApiConstants.serverError,
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  /// Obtener comentarios por ID de noticia
  ///
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    try {
      final response = await dio.get(ApiConstants.comentariosUrl);
      final data = response.data as List<dynamic>;

      final comentarios =
          data.where((json) => json['noticiaId'] == noticiaId).map((json) {
            // Convertir subcomentarios de String a Map si es necesario
            if (json['subcomentarios'] != null) {
              json['subcomentarios'] =
                  (json['subcomentarios'] as List<dynamic>)
                      .map((sub) => sub is String ? jsonDecode(sub) : sub)
                      .toList();
            }
            return ComentarioMapper.fromMap(json);
          }).toList();

      return comentarios;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          message: ApiConstants.errorTimeout,
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiException(
          message: ApiConstants.serverError,
          statusCode: e.response?.statusCode,
        );
      }
      // Manejo de errores
    }
  }

  /// Agrega un comentario nuevo a una noticia existente
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
      isSubComentario: false, // Inicializar como lista vacía
    );

    try {
      await dio.post(
        ApiConstants.comentariosUrl,
        data: nuevoComentario.toMap(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          message: ApiConstants.errorTimeout,
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiException(
          message: ApiConstants.serverError,
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final response = await dio.get(ApiConstants.comentariosUrl);
      final data = response.data as List<dynamic>;

      final comentariosCount =
          data.where((json) => json['noticiaId'] == noticiaId).length;

      return comentariosCount;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          message: ApiConstants.errorTimeout,
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiException(
          message: ApiConstants.serverError,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      return 0;
    }
  }

  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      final response = await dio.get(ApiConstants.comentariosUrl);
      if (response.statusCode != 200) {
        throw ApiException(
          message: ApiConstants.serverError,
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> comentarios = response.data as List<dynamic>;

      // Buscar tanto en comentarios principales como en subcomentarios
      bool encontrado = false;

      for (final comentario in comentarios) {
        // Caso 1: Es un comentario principal
        if (comentario['id'] == comentarioId) {
          final comentarioActualizado = Map<String, dynamic>.from(comentario);

          _aplicarReaccion(comentarioActualizado, tipoReaccion);

          await dio.put(
            '${ApiConstants.comentariosUrl}/$comentarioId',
            data: comentarioActualizado,
          );
          encontrado = true;
          break;
        }

        // Caso 2: Buscar en subcomentarios
        final subcomentarios = _parsearSubcomentarios(
          comentario['subcomentarios'],
        );

        for (final sub in subcomentarios) {
          if (sub is Map && sub['id'] == comentarioId) {
            final subcomentarioActualizado = Map<String, dynamic>.from(sub);

            _aplicarReaccion(subcomentarioActualizado, tipoReaccion);

            // Actualizar lista de subcomentarios del comentario principal
            final comentarioActualizado = Map<String, dynamic>.from(comentario);
            comentarioActualizado['subcomentarios'] =
                subcomentarios
                    .map((s) => s == sub ? subcomentarioActualizado : s)
                    .toList();

            await dio.put(
              '${ApiConstants.comentariosUrl}/${comentario['id']}',
              data: comentarioActualizado,
            );

            encontrado = true;
            break;
          }
        }

        if (encontrado) break;
      }

      if (!encontrado) {
        throw ApiException(
          message: ApiConstants.errorNotFound,
          statusCode: 404,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          message: ApiConstants.errorTimeout,
          statusCode: e.response?.statusCode,
        );
      } else if (e.response?.statusCode == 404) {
        throw ApiException(
          message: ApiConstants.errorNotFound,
          statusCode: 404,
        );
      } else {
        debugPrint('Error DioException: ${e.message}, ${e.response?.data}');
        throw ApiException(
          message: ApiConstants.serverError,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error general al reaccionar al comentario: $e');
      throw ApiException(message: ApiConstants.serverError, statusCode: null);
    }
  }

  // Helper para parsear subcomentarios
  List<dynamic> _parsearSubcomentarios(dynamic subcomentarios) {
    if (subcomentarios is String) {
      try {
        return jsonDecode(subcomentarios) as List<dynamic>;
      } catch (e) {
        debugPrint('Error parseando subcomentarios: $e');
        return [];
      }
    }
    return List<dynamic>.from(subcomentarios ?? []);
  }

  // Helper para aplicar likes/dislikes
  void _aplicarReaccion(Map<String, dynamic> comentario, String tipoReaccion) {
    final clave = tipoReaccion == 'like' ? 'likes' : 'dislikes';
    comentario[clave] = (comentario[clave] ?? 0) + 1;
  }

  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.comentariosUrl}/$comentarioId',
      );
      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'Comentario principal no encontrado',
        };
      }

      final comentarioData = response.data as Map<String, dynamic>;

      // Verificar si el comentario principal es un subcomentario
      if (comentarioData['isSubComentario'] == true) {
        return {
          'success': false,
          'message':
              'No se pueden añadir subcomentarios a otros subcomentarios',
        };
      }

      // Crear nuevo subcomentario
      final nuevoSubcomentario = Comentario(
        id: 'sub_${DateTime.now().millisecondsSinceEpoch}_${texto.hashCode}',
        noticiaId: comentarioData['noticiaId'],
        texto: texto,
        fecha: DateTime.now().toIso8601String(),
        autor: autor,
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: true,
        idSubcomentario: comentarioData['idSubcomentario'],
      );

      // Obtener y validar subcomentarios existentes
      final subcomentariosActuales =
          (comentarioData['subcomentarios'] as List<dynamic>?)
              ?.map(
                (sub) => sub is String ? jsonDecode(sub) : sub,
              ) // 👈 Convertir Strings a Maps
              .toList() ??
          [];

      // Añadir nuevo subcomentario como Map
      subcomentariosActuales.add(nuevoSubcomentario.toMap());

      // Actualizar comentario principal
      await dio.put(
        '${ApiConstants.comentariosUrl}/$comentarioId',
        data: {...comentarioData, 'subcomentarios': subcomentariosActuales},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return {
        'success': true,
        'message': 'Subcomentario agregado correctamente',
      };
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: ${e.toString()}'};
    }
    return {'success': false, 'message': 'Error inesperado'};
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return {'success': false, 'message': ApiConstants.errorTimeout};
    }

    if (e.response?.statusCode == 404) {
      return {'success': false, 'message': ApiConstants.errorNotFound};
    }

    return {
      'success': false,
      'message': '${ApiConstants.serverError}: ${e.message}',
      'statusCode': e.response?.statusCode,
    };
  }
}
