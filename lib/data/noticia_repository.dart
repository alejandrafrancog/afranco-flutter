
import 'package:afranco/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'dart:math';

class NoticiaRepository {
  static final Random _random = Random();
  final Dio _dio = Dio();

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
      // ... (rest of your words remain the same)
    ];
    
    return List.generate(50, (_) => palabras[_random.nextInt(palabras.length)]).join(' ');
  }
  Future<List<Noticia>> getTechnologyNews({
    required int page,       // Página actual
  }) async {
    try {
      final response = await _dio.get(
        NoticiaConstants.newsAPIUrl,
        queryParameters: {
          'q': NoticiaConstants.category,
          'language': NoticiaConstants.language,
          'pageSize': NoticiaConstants.pageSize,
          'page': page,
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

}