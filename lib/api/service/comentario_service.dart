/*import 'dart:convert';
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
*/
import 'package:dart_mappable/dart_mappable.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/comentario.dart';

class ComentarioService extends BaseService {
  final _url = ApiConstantes.comentariosEndpoint;

  /// Obtiene todos los comentarios de una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    final List<dynamic> comentariosJson = await get<List<dynamic>>(
      '$_url?noticiaId=$noticiaId',
      errorMessage: ComentarioConstantes.mensajeError,
    );
    return comentariosJson
        .map<Comentario>(
          (json) => ComentarioMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Agrega un nuevo comentario a una noticia
  Future<Comentario> agregarComentario(Comentario comentario) async {
    final response = await post(
      _url,
      data: comentario.toMap(),
      errorMessage: 'Error al agregar el comentario',
    );
    return ComentarioMapper.fromMap(response);
  }

  /// Calcula el número de comentarios para una noticia específica
  /// Suma también los subcomentarios
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    final comentarios = await obtenerComentariosPorNoticia(noticiaId);
    int contador = comentarios.length;
    for (var comentario in comentarios) {
      if (comentario.subcomentarios != null) {
        contador += comentario.subcomentarios!.length;
      }
    }
    return contador;
  }

  Future<Comentario> obtenerComentarioPorId({
    required String comentarioId,
  }) async {
    final response = await get(
      '$_url/$comentarioId',
      errorMessage: "Error al obtener el comentario",
    );
    return MapperContainer.globals.fromMap<Comentario>(response);
  }

  Future<Comentario> reaccionarComentarioPrincipal({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    final comentario = await obtenerComentarioPorId(comentarioId: comentarioId);

    final comentarioActualizado = _actualizarContadores(
      tipoReaccion: tipoReaccion,
      comentario: comentario,
    );

      final response = await put(
      '$_url/$comentarioId',
      data: comentarioActualizado.toMap(),
      errorMessage: "Error al reaccionar al comentario",
    );
    return ComentarioMapper.fromMap(response);
  }

  /// Busca un subcomentario específico por su ID
  /// Retorna el subcomentario encontrado o null si no existe
  Future<Comentario?> buscarPorSubComentarioId({
    required String subcomentarioId,
  }) async {
    final response = await get(
      '$_url?subcomentarios.id=$subcomentarioId',
      errorMessage: "Error al buscar el subcomentario",
    );

    return ComentarioMapper.fromMap(response[0] as Map<String, dynamic>);
  }

  Future<Comentario> reaccionarSubComentario({
    required String subComentarioId,
    required String tipoReaccion,
  }) async {
    Comentario? comentario = await buscarPorSubComentarioId(
      subcomentarioId: subComentarioId,
    );

    Comentario subComentario;

    if (comentario?.subcomentarios != null) {
      subComentario = (comentario?.subcomentarios)!.firstWhere(
        (sub) => sub.id == subComentarioId,
      );
      subComentario = _actualizarContadores(
        tipoReaccion: tipoReaccion,
        comentario: subComentario,
      );

      comentario = comentario?.copyWith(
        subcomentarios: [
          ...comentario.subcomentarios!.map((sub) {
            if (sub.id == subComentarioId) {
              return subComentario;
            }
            return sub;
          }),
        ],
      );
    }
    final response = await put(
      '$_url/${comentario?.id}',
      data: comentario?.toMap(),
      errorMessage: "Error al reaccionar al subcomentario",
    );
    return ComentarioMapper.fromMap(response);
  }

  Comentario _actualizarContadores({
    Comentario? comentario,
    required String tipoReaccion,
  }) {
    int currentLikes = comentario!.likes;
    int currentDislikes = comentario.dislikes;
    if (tipoReaccion == 'like') {
      currentLikes++;
    } else if (tipoReaccion == 'dislike') {
      currentDislikes++;
    }
    return comentario = comentario.copyWith(
      likes: currentLikes,
      dislikes: currentDislikes,
    );
  }

  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<Comentario> agregarSubcomentario({
    required String comentarioId, // ID del comentario principal
    required Comentario subComentario, // Datos del comentario principal
  }) async {
    final comentario = await obtenerComentarioPorId(comentarioId: comentarioId);
    final subComentariosActualizados = [
      ...?comentario.subcomentarios,
      subComentario,
    ];
    final comentarioActualizado =comentario.copyWith(subcomentarios: subComentariosActualizados);

    final response = await put(
     '$_url/$comentarioId',
      data: comentarioActualizado.toMap(),
      errorMessage: "Error al agregar el subcomentario",
    );
    return ComentarioMapper.fromMap(response);
  }

  Future<void> eliminarComentariosPorNoticia(String noticiaId) async {
    // 1. Primero obtenemos todos los reportes de la noticia
    final comentarios = await obtenerComentariosPorNoticia(noticiaId);
    
    // 2. Eliminamos cada reporte individualmente
    for (final comentario in comentarios) {
      if (comentario.id != null) {
        await delete(
          '$_url/${comentario.id}',
          errorMessage: ReporteConstantes.errorEliminarReportes,
        );
      }
    }
  }
}