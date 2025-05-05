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