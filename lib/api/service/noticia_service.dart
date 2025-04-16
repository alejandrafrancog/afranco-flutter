import '../../data/noticia_repository.dart';
import '../../domain/noticia.dart';

class NoticiaService {
  static const int tamanoPaginaConst = 15;
  final NoticiaRepository _repositorio = NoticiaRepository();

  Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    int tamanoPagina = tamanoPaginaConst,
  }) async {
    // Validación de parámetros de entrada
    _validarParametros(numeroPagina, tamanoPagina);

    // Obtener datos del repositorio
    final noticias = await _repositorio.getNoticiasPaginadas(numeroPagina);
    
    // Validar datos recibidos
    _validarNoticias(noticias);

    return noticias;
  }

  void _validarParametros(int numeroPagina, int tamanoPagina) {
    final errores = <String>[];
    
    if (numeroPagina < 1) {
      errores.add('Número de página ($numeroPagina) debe ser >= 1');
    }
    
    if (tamanoPagina <= 0) {
      errores.add('Tamaño de página ($tamanoPagina) debe ser > 0');
    }
    
    if (errores.isNotEmpty) {
      throw NoticiaServiceException('Parámetros inválidos: ${errores.join(', ')}');
    }
  }

  void _validarNoticias(List<Noticia> noticias) {
    final errores = <String>[];
    
    for (var i = 0; i < noticias.length; i++) {
      final noticia = noticias[i];
      
      if (noticia.titulo.isEmpty) {
        errores.add('Noticia ${i + 1}: Título vacío');
      }
      
      if (noticia.descripcion.isEmpty) {
        errores.add('Noticia ${i + 1}: Descripción vacía');
      }
      
      if (noticia.fuente.isEmpty) {
        errores.add('Noticia ${i + 1}: Fuente vacía');
      }
      
      if (noticia.publicadaEl.isAfter(DateTime.now())) {
        errores.add('Noticia ${i + 1}: Fecha de publicación en el futuro');
      }
    }
    
    if (errores.isNotEmpty) {
      throw NoticiaServiceException('Datos inválidos:\n${errores.join('\n')}');
    }
  }
}

class NoticiaServiceException implements Exception {
  final String message;
  NoticiaServiceException(this.message);
  
  @override
  String toString() => 'NoticiaServiceException: $message';
}