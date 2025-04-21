import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/domain/noticia.dart';
class NoticiaService {
  static const int tamanoPaginaConst = 10;
  final NoticiaRepository _repositorio = NoticiaRepository();

  /*Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    int tamanoPagina = tamanoPaginaConst,
  }) async {
    // Validación de parámetros
    _validarParametros(numeroPagina, tamanoPagina);

    // Obtener datos del repositorio CON paginación
    final noticias = await _repositorio.getTechnologyNews(
      page: numeroPagina,
      pageSize: tamanoPagina,
    );

    // Validar datos recibidos
    _validarNoticias(noticias);

    return noticias;
  }*/
    final Set<String> _noticiasIds = {}; // Almacena IDs únicos

    Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    int tamanoPagina = tamanoPaginaConst,
  }) async {
    _validarParametros(numeroPagina, tamanoPagina);

    // Paso 1: Obtener noticias del repositorio
    final noticias = await _repositorio.getTechnologyNews(
      page: numeroPagina,
    );

    // Paso 2: Filtrar duplicados (nuevo)
    final noticiasUnicas = noticias.where((noticia) {
      final isDuplicado = _noticiasIds.contains(noticia.id);
      if (!isDuplicado) _noticiasIds.add(noticia.id); // Registra ID nuevo
      return !isDuplicado;
    }).toList();

    // Paso 3: Validar (opcional, si mantienes tu lógica actual)
    _validarNoticias(noticiasUnicas);

    return noticiasUnicas;
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