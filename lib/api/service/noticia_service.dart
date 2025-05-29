import 'dart:async';
import 'dart:math';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:flutter/foundation.dart';

class NoticiaService extends BaseService {
  static final Random _random = Random();
  final String _baseUrl = ApiConstants.urlNoticias;

  final _titulosPosibles = [
    "Se reeligió al presidente en una ajustada votación",
    "Nueva ley de educación entra en vigor",
  ];

  NoticiaService() : super();

  /// Obtiene noticias paginadas (generadas localmente)
  Future<List<Noticia>> getNoticiasPaginadas(int pagina) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (pagina <= 0) {
        throw ApiException(
          message: NoticiaConstants.errorPaginaInvalida,
          statusCode: 400,
        );
      }

      return List.generate(
        NoticiaConstants.pageSize,
        (index) => _generarNoticia(pagina, index),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: NoticiaConstants.errorGenerico,
        statusCode: 520,
      );
    }
  }

  Noticia _generarNoticia(int pagina, int index) {
    final id = '${pagina}_$index';
    final fuente =
        NoticiaConstants.fuentes[_random.nextInt(
          NoticiaConstants.fuentes.length,
        )];
    final diasAleatorios = _random.nextInt(365);
    final titulo = _titulosPosibles[_random.nextInt(_titulosPosibles.length)];

    return Noticia(
      id: id,
      titulo: titulo,
      fuente: fuente,
      urlImagen: '',
      publicadaEl: DateTime.now().subtract(Duration(days: diasAleatorios)),
      descripcion: _generarContenidoAleatorio(),
    );
  }

  String _generarContenidoAleatorio() {
    const palabras = ['Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur'];

    return List.generate(
      50,
      (_) => palabras[_random.nextInt(palabras.length)],
    ).join(' ');
  }

  /// Obtiene noticias de tecnología con paginación
  Future<List<Noticia>> getTechnologyNews({required int page}) async {
    final queryParams = {
      'q': NoticiaConstants.category,
      'language': NoticiaConstants.language,
      'pageSize': NoticiaConstants.pageSize,
      'page': page,
      'sortBy': 'publishedAt',
    };

    final data = await get<Map<String, dynamic>>(
      _baseUrl,
      queryParameters: queryParams,
      errorMessage: NoticiaConstants.errorObtenerNoticias,
    );

    if (data['status'] == 'ok' && data['articles'] != null) {
      return (data['articles'] as List)
          .map((json) => NoticiaMapper.fromMap(json))
          .toList();
    }
    throw ApiException(
      message: NoticiaConstants.errorFormatoInvalido,
      statusCode: 500,
    );
  }

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
      },
      errorMessage: NoticiaConstants.errorActualizarNoticia,
      requireAuthToken: true,
    );

    debugPrint('✅ Noticia actualizada con éxito');
  }

  /// Obtiene todas las noticias tecnológicas
  Future<List<Noticia>> getTechNews({required int page}) async {
    debugPrint('📋 Obteniendo noticias de tecnología');

    final data = await get<List<dynamic>>(
      _baseUrl,
      errorMessage: NoticiaConstants.errorObtenerNoticiasTecno,
    );

    return data.map((json) => NoticiaMapper.fromMap(json)).toList();
  }

  /// Elimina una noticia por su ID
  Future<void> eliminarNoticia(String id) async {
    debugPrint('🗑️ Eliminando noticia con ID: $id');

    await delete(
      '$_baseUrl/$id',
      errorMessage: NoticiaConstants.errorEliminarNoticia,
      requireAuthToken: true,
    );

    debugPrint('✅ Noticia eliminada correctamente');
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

  /// Elimina una noticia y retorna la respuesta completa
  Future<void> deleteNoticia(String id) async {
    debugPrint('🗑️ Eliminando noticia con ID: $id');

    await delete(
      '$_baseUrl/$id',
      errorMessage: NoticiaConstants.errorEliminarNoticia,
      requireAuthToken: true,
    );

    debugPrint('✅ Noticia eliminada correctamente');
  }
}
