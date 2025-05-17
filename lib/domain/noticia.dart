import 'dart:math';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:afranco/domain/categoria.dart';

part 'noticia.mapper.dart';

@MappableClass()
class Noticia with NoticiaMappable {
  final String id;
  
  // Fix: Map categoryId to categoriaId from JSON
  @MappableField(key: 'categoriaId')
  final String categoryId;
  
  final String titulo;
  final String fuente;
  @MappableField(key: 'urlImagen')
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

  Future<String> obtenerNombreCategoria(Future<List<Categoria>> categorias, String catID) async {
    if (catID.isEmpty || catID == "sin_categoria") return 'Sin categoría';
    
    List<Categoria> categoriasList = await categorias;
    for (Categoria cat in categoriasList) {
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
