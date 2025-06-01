
// Eventos actuales
abstract class ComentarioEvent {}

class LoadComentarios extends ComentarioEvent {
  final String noticiaId;

  LoadComentarios({required this.noticiaId});
}

class AddComentario extends ComentarioEvent {
  final String noticiaId;
  final String texto;
  final String autor;
  final String fecha;

  AddComentario({
    required this.noticiaId,
    required this.texto,
    required this.autor,
    required this.fecha,
  });
}

class GetNumeroComentarios extends ComentarioEvent {
  final String noticiaId;

  GetNumeroComentarios({required this.noticiaId});
}

class BuscarComentarios extends ComentarioEvent {
  final String noticiaId;
  final String criterioBusqueda;

  BuscarComentarios({
    required this.noticiaId,
    required this.criterioBusqueda,
  });
}

class OrdenarComentarios extends ComentarioEvent {
  final bool ascendente;

  OrdenarComentarios({this.ascendente = false});
}

class AddReaccion extends ComentarioEvent {
  final String noticiaId;
  final String comentarioId;
  final String tipoReaccion;

  AddReaccion({
    required this.noticiaId,
    required this.comentarioId,
    required this.tipoReaccion,
  });
}

class AddSubcomentario extends ComentarioEvent {
  final String noticiaId;
  final String comentarioId;
  final String texto;
  final String autor;

  AddSubcomentario({
    required this.noticiaId,
    required this.comentarioId,
    required this.texto,
    required this.autor,
  });
}

// Nuevo evento para invalidar la caché
class InvalidateCache extends ComentarioEvent {
  final String noticiaId;

  InvalidateCache({required this.noticiaId});
}

class AddReaccionSubcomentario extends ComentarioEvent {
  final String noticiaId;
  final String subcomentarioId;
  final String tipoReaccion; // 'like' o 'dislike'

  AddReaccionSubcomentario({
    required this.noticiaId,
    required this.subcomentarioId,
    required this.tipoReaccion,
  });

  List<Object> get props => [noticiaId, subcomentarioId, tipoReaccion];
}
