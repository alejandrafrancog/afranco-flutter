import 'package:afranco/api/service/noticia_service.dart';
import 'package:afranco/data/base_repository.dart';
import 'package:afranco/domain/noticia.dart';

class NoticiaRepository extends BaseRepository {
  static const int tamanoPaginaConst = 10;
  final NoticiaService _service = NoticiaService();

  Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    required bool ordenarPorFecha,
  }) async {
    return handleApiCall(() async {
      final noticias = await _service.getTechNews(page: numeroPagina);
      return ordenarPorFecha
          ? _ordenarPorFechaDescendente(noticias)
          : _ordenarPorFuenteAscendente(noticias);
    });
  }

  Future<List<Noticia>> obtenerNoticias() async {
    return handleApiCall(() => _service.getTechNews(page: 1));
  }

  List<Noticia> _ordenarPorFechaDescendente(List<Noticia> noticias) {
    noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));
    return noticias;
  }

  List<Noticia> _ordenarPorFuenteAscendente(List<Noticia> noticias) {
    noticias.sort(
      (a, b) => a.fuente
          .toLowerCase()
          .replaceAll(RegExp(r'[áäà]'), 'a')
          .compareTo(b.fuente.toLowerCase().replaceAll(RegExp(r'[áäà]'), 'a')),
    );
    return noticias;
  }

  Future<void> crearNoticia(Noticia noticia) async {
    checkForEmpty([
      MapEntry('título', noticia.titulo),
      MapEntry('descripcion', noticia.descripcion),
      MapEntry('fuente', noticia.fuente),
    ]);

    await handleApiCall(() => _service.createNoticia(noticia));
  }

  Future<void> eliminarNoticia(String id) async {
    await handleApiCall(() => _service.eliminarNoticia(id));
  }

  Future<void> actualizarNoticia(Noticia noticia) async {
    checkForEmpty([
      MapEntry('id', noticia.id),
      MapEntry('título', noticia.titulo),
      MapEntry('descripcion', noticia.descripcion),
    ]);

    await handleApiCall(() => _service.updateNoticia(noticia));
  }
    Future<Noticia> obtenerNoticiaPorId(String id) async {
    checkForEmpty([MapEntry('id', id)]);
    return handleApiCall(() => _service.getNoticiaById(id));
  }
}
