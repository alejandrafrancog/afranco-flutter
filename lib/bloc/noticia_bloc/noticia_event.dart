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

// NUEVOS EVENTOS PARA DISTINGUIR OPERACIONES ESPECÍFICAS
class NoticiaCreatedEvent extends NoticiaEvent {
  final Noticia? noticia; // Opcional, por si necesitas pasar la noticia creada
  NoticiaCreatedEvent({this.noticia});
}

class NoticiaEditedEvent extends NoticiaEvent {
  final Noticia? noticia; // Opcional, por si necesitas pasar la noticia editada
  NoticiaEditedEvent({this.noticia});
}

class NoticiaDeletedEvent extends NoticiaEvent {
  final String? noticiaId; // Opcional, por si necesitas el ID de la noticia eliminada
  NoticiaDeletedEvent({this.noticiaId});
}