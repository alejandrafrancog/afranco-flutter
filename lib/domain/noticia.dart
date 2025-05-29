import 'dart:math';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:afranco/domain/categoria.dart';

part 'noticia.mapper.dart';

@MappableClass()
class Noticia with NoticiaMappable {
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  final String? categoriaId;
  final int? contadorReportes;
  final int? contadorComentarios;
  final int tiempoLectura =
      _generarTiempoLectura(); // Tiempo de lectura en minutos

  Noticia({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    this.categoriaId,
    this.contadorReportes,
    this.contadorComentarios,
  });

  static int _generarTiempoLectura() {
    final random = Random();
    return random.nextInt(10) + 1;
  }

  Future<String> obtenerNombreCategoria(
    Future<List<Categoria>> categorias,
    String catID,
  ) async {
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
