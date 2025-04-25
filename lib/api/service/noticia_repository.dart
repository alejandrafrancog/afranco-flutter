import 'package:afranco/data/noticia_service.dart';
import 'package:afranco/domain/noticia.dart';
class NoticiaRepository {
  static const int tamanoPaginaConst = 10;
  final NoticiaService _service = NoticiaService();


// En NoticiaService
Future<List<Noticia>> obtenerNoticiasPaginadas({
  required int numeroPagina,
  required bool ordenarPorFecha,
}) async {
  final noticias = await _service.getTechNews(page: numeroPagina);
  
  // Ordenamiento definitivo (considera mayúsculas y tildes)
  return ordenarPorFecha 
    ? _ordenarPorFechaDescendente(noticias)
    : _ordenarPorFuenteAscendente(noticias);
}

List<Noticia> _ordenarPorFechaDescendente(List<Noticia> noticias) {
  noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));
  return noticias;
}

List<Noticia> _ordenarPorFuenteAscendente(List<Noticia> noticias) {
  noticias.sort((a, b) => a.fuente
      .toLowerCase()
      .replaceAll(RegExp(r'[áäà]'), 'a')
      .compareTo(b.fuente
          .toLowerCase()
          .replaceAll(RegExp(r'[áäà]'), 'a')));
  return noticias;
}
    Future<void> crearNoticia(Noticia noticia) async {
    try {
      await NoticiaService().createNoticia(noticia);
    } catch (e) {
      throw NoticiaServiceException('Error creando noticia: ${e.toString()}');
    }
  }


 Future<void> eliminarNoticia(String id) async {
  await _service.eliminarNoticia(id);
}

Future<void> actualizarNoticia(Noticia noticia) async {
  await _service.updateNoticia(noticia);
}

}

class NoticiaServiceException implements Exception {
  final String message;
  NoticiaServiceException(this.message);
  
  @override
  String toString() => 'NoticiaServiceException: $message';
}