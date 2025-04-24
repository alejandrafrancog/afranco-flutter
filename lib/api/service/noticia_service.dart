import 'package:afranco/data/noticia_repository.dart';
import 'package:afranco/domain/noticia.dart';
class NoticiaService {
  static const int tamanoPaginaConst = 10;
  final NoticiaRepository _repositorio = NoticiaRepository();


// En NoticiaService
Future<List<Noticia>> obtenerNoticiasPaginadas({
  required int numeroPagina,
  required bool ordenarPorFecha,
}) async {
  final noticias = await _repositorio.getTechNews(page: numeroPagina);
  
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
      await NoticiaRepository().createNoticia(noticia);
    } catch (e) {
      throw NoticiaServiceException('Error creando noticia: ${e.toString()}');
    }
  }


 Future<void> eliminarNoticia(String id) async {
  await _repositorio.eliminarNoticia(id);
}

Future<void> actualizarNoticia(Noticia noticia) async {
  await _repositorio.updateNoticia(noticia);
}

}

class NoticiaServiceException implements Exception {
  final String message;
  NoticiaServiceException(this.message);
  
  @override
  String toString() => 'NoticiaServiceException: $message';
}