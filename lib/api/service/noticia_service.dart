import 'dart:async';
import 'dart:math';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NoticiaService extends BaseService {
  static final Random _random = Random();
  final String _baseUrl = ApiConstants.urlNoticias;
  
  // Lista de títulos posibles para noticias generadas
  final _titulosPosibles = [
    "Se reeligió al presidente en una ajustada votación",
    "Nueva ley de educación entra en vigor",
  ];

  // Constructor
  NoticiaService() : super();

  /// Obtiene noticias paginadas (generadas localmente)
  Future<List<Noticia>> getNoticiasPaginadas(int pagina) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (pagina <= 0) {
        throw ApiException(
          message: 'Número de página inválido',
          statusCode: 400, // Bad Request
        );
      }   

      return List.generate(
        NoticiaConstants.pageSize,
        (index) => _generarNoticia(pagina, index),
      );
    } catch (e) {
      // Lanza la ApiException si es necesario
      if (e is ApiException) {
        rethrow; // Si es un ApiException, simplemente lo volvemos a lanzar
      } else {
        throw ApiException(
          message: 'Error desconocido al obtener noticias',
          statusCode: 520, // Error genérico
        );
      }
    }
  }
  
  /// Genera una noticia de ejemplo
  Noticia _generarNoticia(int pagina, int index) {
    // Genera datos únicos y aleatorios
    final id = '${pagina}_$index';
    final fuente = NoticiaConstants.fuentes[_random.nextInt(NoticiaConstants.fuentes.length)];
    final diasAleatorios = _random.nextInt(365);
    final titulo = _titulosPosibles[_random.nextInt(_titulosPosibles.length)];
    
    return Noticia(
      id: id,
      titulo: titulo,
      fuente: fuente,
      urlImagen: '',
      publicadaEl: DateTime.now().subtract(Duration(days: diasAleatorios)),
      descripcion: _generarContenidoAleatorio(),
      url: '',
    );
  }

  /// Genera contenido aleatorio para descripciones
  String _generarContenidoAleatorio() {
    const palabras = [
      'Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
    ];
    
    return List.generate(50, (_) => palabras[_random.nextInt(palabras.length)]).join(' ');
  }

  /// Obtiene noticias de tecnología con paginación
  Future<List<Noticia>> getTechnologyNews({required int page}) async {
    try {
      final queryParams = {
        'q': NoticiaConstants.category,
        'language': NoticiaConstants.language,
        'pageSize': NoticiaConstants.pageSize,
        'page': page,
        'sortBy': 'publishedAt',
      };
      
      final data = await get(
        _baseUrl,
        queryParameters: queryParams,
        requireAuthToken: false,
      );

      final Map<String, dynamic> responseData = data;
      if (responseData['status'] == 'ok' && responseData['articles'] != null) {
        return (responseData['articles'] as List)
            .map((json) => NoticiaMapper.fromJson(json))
            .toList();
      }
      return [];
      
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en getTechnologyNews: ${e.toString()}');
      throw ApiException(message: 'Error inesperado: $e', statusCode: 500);
    }
  }
  
  /// Crea una nueva noticia
  Future<void> createNoticia(Noticia noticia) async {
    try {
      debugPrint('➕ Creando nueva noticia');
      
      await post(
        _baseUrl,
        data: {
          'categoriaId': noticia.categoryId,
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImagen': noticia.urlImagen,
          'url': noticia.url,
        },
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia creada con éxito');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en createNoticia: ${e.toString()}');
      throw ApiException(message: 'Error en la creación: $e', statusCode: 500);
    }
  }
  
  /// Actualiza una noticia existente
  Future<void> updateNoticia(Noticia noticia, {String? titulo, String? categoriaId, String? descripcion, String? fuente}) async {
    try {
      debugPrint('🔄 Actualizando noticia con ID: ${noticia.id}');
      
      await put(
        '$_baseUrl/${noticia.id}',
        data: {
          'titulo': titulo ?? noticia.titulo,
          'categoriaId': categoriaId ?? noticia.categoryId,
          'descripcion': descripcion ?? noticia.descripcion,
          'fuente': fuente ?? noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImagen': noticia.urlImagen,
        },
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia actualizada con éxito');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en updateNoticia: ${e.toString()}');
      throw ApiException(message: 'Error en la actualización: $e', statusCode: 500);
    }
  }

  /// Obtiene todas las noticias tecnológicas
  Future<List<Noticia>> getTechNews({required int page}) async {
    try {
      debugPrint('📋 Obteniendo noticias de tecnología');
      
      final data = await get(
        _baseUrl,
        requireAuthToken: false,
      );
      
      if (data is List) {
        final List<dynamic> noticiasJson = data;
        return noticiasJson.map((json) => NoticiaMapper.fromMap(json)).toList();
      } else {
        throw ApiException(
          message: 'Formato de respuesta inválido',
          statusCode: 500,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en getTechNews: ${e.toString()}');
      throw ApiException(message: 'Error inesperado: $e', statusCode: 500);
    }
  }
  
  /// Elimina una noticia por su ID
  Future<void> eliminarNoticia(String id) async {
    try {
      debugPrint('🗑️ Eliminando noticia con ID: $id');
      
      await delete('$_baseUrl/$id', requireAuthToken: true);
      
      debugPrint('✅ Noticia eliminada correctamente');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en eliminarNoticia: ${e.toString()}');
      throw ApiException(message: 'Error al eliminar la noticia: $e', statusCode: 500);
    }
  }

  /// Actualiza una noticia y retorna el objeto actualizado
  Future<Noticia> actualizarNoticia(Noticia noticia) async {
    try {
      debugPrint('🔄 Actualizando noticia completa con ID: ${noticia.id}');
      
      final data = await put(
        '$_baseUrl/${noticia.id}',
        data: noticia.toJson(),
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia actualizada con éxito');
      return NoticiaMapper.fromJson(data);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en actualizarNoticia: ${e.toString()}');
      throw ApiException(message: 'Error al actualizar la noticia: $e', statusCode: 500);
    }
  }
  
  /// Elimina una noticia y retorna la respuesta completa
  Future<Response> deleteNoticia(String id) async {
    try {
      debugPrint('🗑️ Eliminando noticia con ID: $id (con respuesta)');
      
      // Usamos el método delete de BaseService que ya maneja la autenticación 
      // y capturamos la respuesta directamente
      final responseData = await delete(
        '$_baseUrl/$id', 
        requireAuthToken: true
      );
      
      // Simulamos una respuesta Dio ya que BaseService solo retorna los datos
      // Esto es para mantener compatibilidad con el código existente
      final response = Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '$_baseUrl/$id')
      );
      
      debugPrint('✅ Noticia eliminada correctamente');
      return response;
    } catch (e) {
      if (e is DioException) {
        handleError(e);
      } else if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en deleteNoticia: ${e.toString()}');
      throw ApiException(message: 'Error al eliminar la noticia: $e', statusCode: 500);
    }
  }
}