import 'package:afranco/domain/noticia.dart';

abstract class NoticiaEvent {}

class NoticiaCargadaEvent extends NoticiaEvent{}
class NoticiaCargarMasEvent extends NoticiaEvent{}
class NoticiaRecargarEvent extends NoticiaEvent{}
class NoticiaLimpiarErrorEvent extends NoticiaEvent{}
class FilterNoticiasByPreferencias extends NoticiaEvent {
  final List<String> categoriasIds;

  FilterNoticiasByPreferencias(this.categoriasIds);

}
class FetchNoticias extends NoticiaEvent {
  FetchNoticias();
}
class UpdateNoticiaEvent extends NoticiaEvent {
  final Noticia noticia;
  UpdateNoticiaEvent(this.noticia);
}

class DeleteNoticiaEvent extends NoticiaEvent {
  final String id;
  DeleteNoticiaEvent(this.id);
}

class AddNoticiaEvent extends NoticiaEvent {
  final Noticia noticia;
  AddNoticiaEvent(this.noticia);
}