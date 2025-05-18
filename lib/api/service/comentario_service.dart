import 'dart:convert';

import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:dio/dio.dart';
import 'package:afranco/exceptions/api_exception.dart';

class ComentarioService {
  final Dio dio = Dio();

  Future<void> _verificarNoticiaExiste(String noticiaId) async {
    try {
      //final response = await dio.get('$baseUrl$noticiasEndpoint/$noticiaId');
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

      // Buscar si es un comentario principal
      final comentarioIndex = comentarios.indexWhere(
        (c) => c['id'] == comentarioId,
      );
      if (comentarioIndex != -1) {
        Map<String, dynamic> comentarioActualizado = Map<String, dynamic>.from(
          comentarios[comentarioIndex],
        );

        int currentLikes = comentarioActualizado['likes'] ?? 0;
        int currentDislikes = comentarioActualizado['dislikes'] ?? 0;

        await dio.put(
          '${ApiConstants.comentariosUrl}/$comentarioId',
          data: {
            'noticiaId': comentarioActualizado['noticiaId'],
            'texto': comentarioActualizado['texto'],
            'fecha': comentarioActualizado['fecha'],
            'autor': comentarioActualizado['autor'],
            'likes': tipoReaccion == 'like' ? currentLikes + 1 : currentLikes,
            'dislikes':
                tipoReaccion == 'dislike'
                    ? currentDislikes + 1
                    : currentDislikes,
            'subcomentarios': comentarioActualizado['subcomentarios'] ?? [],
            'isSubComentario':
                comentarioActualizado['isSubComentario'] ?? false,
          },
        );
        return;
      }

      // Buscar en subcomentarios
      for (int i = 0; i < comentarios.length; i++) {
        final comentarioPrincipal = Map<String, dynamic>.from(comentarios[i]);
        final List<dynamic> subcomentarios = List<dynamic>.from(
          comentarioPrincipal['subcomentarios'] ?? [],
        );

        for (int j = 0; j < subcomentarios.length; j++) {
          final subcomentario = Map<String, dynamic>.from(subcomentarios[j]);

          if (subcomentario['id'] == comentarioId) {
            int currentLikes = subcomentario['likes'] ?? 0;
            int currentDislikes = subcomentario['dislikes'] ?? 0;

            subcomentario['likes'] =
                tipoReaccion == 'like' ? currentLikes + 1 : currentLikes;
            subcomentario['dislikes'] =
                tipoReaccion == 'dislike'
                    ? currentDislikes + 1
                    : currentDislikes;

            subcomentarios[j] = subcomentario;

            comentarioPrincipal['subcomentarios'] = subcomentarios;

            await dio.put(
              '${ApiConstants.comentariosUrl}/${comentarioPrincipal['id']}',
              data: comentarioPrincipal,
            );
            return;
          }
        }
      }

      throw ApiException(message: ApiConstants.errorNotFound, statusCode: 404);
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
    } catch (e) {
      throw ApiException(message: ApiConstants.serverError, statusCode: null);
    }
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
        idSubComentario: comentarioId,
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
