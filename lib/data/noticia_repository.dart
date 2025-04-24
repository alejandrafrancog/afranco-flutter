
import 'package:afranco/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'dart:math';

class NoticiaRepository {
  static final Random _random = Random();
  final Dio _dio = Dio();
  static String _baseUrl = 'https://crudcrud.com/api/${NoticiaConstants.crudApiUrl}/noticias';

  final _titulosPosibles = [
    "Se reeligió al presidente en una ajustada votación",
    "Nueva ley de educación entra en vigor",
    // ... (rest of your titles remain the same)
  ];

  Future<List<Noticia>> getNoticiasPaginadas(int pagina) async {
    // Simula retardo de red
    await Future.delayed(const Duration(seconds: 2));
    
    return List.generate(
      NoticiaConstants.pageSize,
      (index) => _generarNoticia(pagina, index),
    );
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
  Future<List<Noticia>> getTechnologyNews({
    required int page,       // Página actual
  }) async {
    try {
      final response = await _dio.get(
        NoticiaConstants.crudApiUrl,
        queryParameters: {
          'q': NoticiaConstants.category,
          'language': NoticiaConstants.language,
          'pageSize': NoticiaConstants.pageSize,
          'page': page,
          'sortBy':'publishedAt',
        },
        options: Options(
          headers: {
            'X-Api-Key': NoticiaConstants.newsApiKey,
          },
        ),
        );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data['status'] == 'ok' && data['articles'] != null) {
          return (data['articles'] as List)
              .map((json) => Noticia.fromJson(json))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      print('Error: ${e.response?.data ?? e.message}');
      return [];
    }
  }
  /*Future<void> createNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        NoticiaConstants.curlApiUrl,
        data: {
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
      throw Exception('Error de red: ${e.message}');
    }
  }
  Future<List<Noticia>> getTechNews({
    required int page,
  }) async {
    try {
      final response = await _dio.get(
        NoticiaConstants.curlApiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json', // ← Fuerza JSON válido

          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromCrudApiJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error: ${e.response?.data ?? e.message}');
      return [];
    }
  }*/
    
  Future<void> createNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        NoticiaConstants.crudApiUrl,
        data: {
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
    Future<void> updateNoticia(Noticia noticia, {String? titulo, String? descripcion,String? fuente}) async {
    try {
      final response = await _dio.put(
        '${NoticiaConstants.crudApiUrl}/${noticia.id}',
        data: {
          'titulo': titulo ?? noticia.titulo,
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
        NoticiaConstants.crudApiUrl,
        options: Options(headers: {}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromCrudApiJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _handle4xxError(e); // Nueva función de manejo de errores
      print('Error: ${e.response?.data ?? e.message}');
      return [];
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
        '${NoticiaConstants.crudApiUrl}/$id',
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