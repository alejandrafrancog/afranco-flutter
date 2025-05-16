import 'dart:math';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:afranco/domain/categoria.dart';

part 'noticia.mapper.dart';

@MappableClass()
class Noticia with NoticiaMappable {
  @MappableField(key: 'urlImagen')
  final String id;
  final String categoryId;
  final String titulo;
  final String fuente;
  final String urlImagen;
  final DateTime publicadaEl;
  final String descripcion;
  final int tiempoLectura;
  final String? url;
  final String? autor;
  final String? contenido;

  Noticia({
    required this.id,
    String? categoryId,
    required this.titulo,
    required this.fuente,
    required this.urlImagen,
    required this.publicadaEl,
    required this.descripcion,
    this.url,
    this.autor,
    this.contenido,
    int? tiempoLectura,
  })  : categoryId = categoryId ?? "",
        tiempoLectura = tiempoLectura ?? _generarTiempoLectura();

  static int _generarTiempoLectura() {
    final random = Random();
    return random.nextInt(10) + 1;
  }

  // Métodos que no se serializan
  Future<String> obtenerNombreCategoria(Future<List<Categoria>> categorias, String catID) async {
    List<Categoria> categoriasList = await categorias;
    for (Categoria cat in categoriasList) {
      print('$cat.id == $catID');
      if (cat.id == catID) return cat.nombre;
    }
    return 'Sin categoría';
  }


  String fechaCorta() {
    return '${publicadaEl.day}/${publicadaEl.month}/${publicadaEl.year}';
  }

  String tiempoLecturaFormateado() {
    return '$tiempoLectura min${tiempoLectura > 1 ? 's' : ''}';
  }

}
