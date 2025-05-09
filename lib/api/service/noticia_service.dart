
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:afranco/exceptions/api_exception.dart';
class NoticiaService {
  static final Random _random = Random();
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds:CategoriaConstants.timeOutSeconds),
      receiveTimeout: const Duration(seconds:CategoriaConstants.timeOutSeconds),
    ),
  );
  final String _baseUrl = ApiConstants.urlNoticias;

  final _titulosPosibles = [
    "Se reeligió al presidente en una ajustada votación",
    "Nueva ley de educación entra en vigor",
  ];

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
      imagen: '',
      publicadaEl: DateTime.now().subtract(Duration(days: diasAleatorios)),
      descripcion: _generarContenidoAleatorio(),
      url: '',
    );
  }

  String _generarContenidoAleatorio() {
    const palabras = [
      'Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
      
    ];
    
    return List.generate(50, (_) => palabras[_random.nextInt(palabras.length)]).join(' ');
  }
  Future<List<Noticia>> getTechnologyNews({required int page}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'q': NoticiaConstants.category,
          'language': NoticiaConstants.language,
          'pageSize': NoticiaConstants.pageSize,
          'page': page,
          'sortBy': 'publishedAt',
        },
        /*options: Options(
          headers: {
            'X-Api-Key': ApiConstants.newsApiKey,
          },
        ),*/
      ).timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> data = response.data;
          if (data['status'] == 'ok' && data['articles'] != null) {
            return (data['articles'] as List)
                .map((json) => Noticia.fromJson(json))
                .toList();
          }
          return [];
        case 400:
          throw Exception("Error 400");
        case 401:
          throw Exception('No autorizado');
        case 404:
          throw Exception('Noticias no encontradas');
        case 500:
          throw Exception('Error del servidor');
        default:
          throw Exception('Error inesperado: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw Exception(e.toString());
      } else {
        throw Exception('Error de red: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

    
  Future<void> createNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: {
          'categoriaId':noticia.categoryId,
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImagen': noticia.imagen,
          'url': noticia.url,
          
        },
      );
      
      if (response.statusCode != 201) {
        throw Exception('Error en la creación');
      }
    } on DioException catch (e) {
      _handle4xxError(e); // Nueva función de manejo de errores
      throw Exception('Error de red: ${e.message}');
    }
  }
    Future<void> updateNoticia(Noticia noticia, {String? titulo, String? categoriaId,String? descripcion,String? fuente}) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${noticia.id}',
        data: {
          'titulo': titulo ?? noticia.titulo,
          'categoriaId':categoriaId ?? noticia.categoryId,
          'descripcion': descripcion ?? noticia.descripcion,
          'fuente': fuente ?? noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImagen': noticia.imagen,
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('Error en la actualización');
      }
    } on DioException catch (e) {
      _handle4xxError(e); // Nueva función de manejo de errores
      throw Exception('Error de red: ${e.message}');
    }
  }

Future<List<Noticia>> getTechNews({required int page}) async {
  try {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {}),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Noticia.fromCrudApiJson(json)).toList();
    } else {
      // En caso de que el código de estado no sea 200
      throw ApiException(
        message: 'Error en la solicitud. Código: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (e) {
    // No manejamos el error aquí, lo propagamos
    throw ApiException(
      message: 'Error de conexión: ${e.message}',
      statusCode: e.response?.statusCode,
    );
  } catch (e) {
    // Para otros errores, también los propagamos
    throw ApiException(
      message: 'Error inesperado: ${e.toString()}',
      statusCode: null,
    );
  }
}


  void _handle4xxError(DioException e) {
    if (e.response?.statusCode != null && 
        e.response!.statusCode! >= 400 && 
        e.response!.statusCode! < 500) {
      final errorMessage = _extractErrorMessage(e.response!.data);
      throw Exception('Error ${e.response?.statusCode}: $errorMessage');
    }
  }
  Future<void> eliminarNoticia(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la noticia');
      }
    } on DioException catch (e) {
      _handle4xxError(e);
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<Noticia> actualizarNoticia(Noticia noticia) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${noticia.id}',
        data: noticia.toJson(),
      );
      
      if (response.statusCode == 200) {
        return Noticia.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar la noticia');
      }
    } on DioException catch (e) {
      _handle4xxError(e);
      throw Exception('Error de red: ${e.message}');
    }
  }
  Future<Response> deleteNoticia(String id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/$id',
      );
      return response;
    } on DioException catch (e) {
      _handle4xxError(e);
      throw Exception('Error de red: ${e.message}');
    }
  }
  
  // Función para extraer mensaje de error de diferentes formatos de respuesta
  String _extractErrorMessage(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      return errorData['message'] ?? errorData.toString();
    }
    if (errorData is String) {
      return errorData;
    }
    return 'Error desconocido en la operación';
  }

}