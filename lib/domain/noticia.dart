import 'dart:math';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/category.dart';

class Noticia {
  final String id;
  final String categoryId;
  final String titulo;
  final String fuente;
  final String imagen;
  final DateTime publicadaEl;
  final String descripcion;
  final int tiempoLectura;
  final String url;
  final String? autor;
  final String? contenido;

  Noticia({
    required this.id,
    String? categoryId,
    required this.titulo,
    required this.fuente,
    required this.imagen,
    required this.publicadaEl,
    required this.descripcion,
    required this.url,
    this.autor,
    this.contenido,
  }) :categoryId = categoryId ?? NoticiaConstants.sinCategoria,
  tiempoLectura = _generarTiempoLectura();

  static int _generarTiempoLectura() {
    final random = Random();
    return random.nextInt(10) + 1; // 1-10 minutos
  }

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['url'] ?? '', // Using URL as unique ID
      titulo: json['title'] ?? '',
      fuente: json['source']['name'] ?? '',
      imagen: json['urlToImage'] ?? '',
      publicadaEl: DateTime.parse(json['publishedAt'] ?? DateTime.now().toString()),
      descripcion: json['description'] ?? '',
      url: json['url'] ?? '',
      autor: json['author'],
      contenido: json['content'],
    );
  }
  Map<String, dynamic> toJson() {
  return {
    '_id': id,
    'categoriaId': categoryId, // Añadir categoriaId al JSON
    'titulo': titulo,
    'descripcion': descripcion,
    'fuente': fuente,
    'publicadaEl': publicadaEl.toIso8601String(),
    'url': url,
  };
}


factory Noticia.fromCrudApiJson(Map<String, dynamic> json) {
    // Verifica el formato de fecha y provee un valor por defecto si falla
  DateTime parsearFecha(String fechaStr) {
    try {
      return DateTime.parse(fechaStr);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  Random random = Random(100);
  return Noticia(
    id: json['_id'] ?? '',
    categoryId: json['categoriaId'] ?? '',
    titulo: json['titulo'] ?? '',
    fuente: json['fuente'] ?? 'Fuente desconocida',
    imagen: json['urlImagen'] ?? 'https://picsum.photos/200/300?random=${random.toString()}',
    publicadaEl: parsearFecha(json['publicadaEl'] ?? DateTime.now().toIso8601String()),
    descripcion: json['descripcion'] ?? 'Default description...',
    url: json['url'] ?? '',
  );
  
}

  Future<String> obtenerNombreCategoria(Future<List<Categoria>> categorias) async {
    List<Categoria> categoriasList = await categorias;
    for (Categoria cat in categoriasList) {
      if (cat.id == categoryId) { // Usa categoryId de la noticia, no el id de la noticia
        return cat.nombre;
      }
    } 
    return 'Sin categoría';
  }
  Future<Categoria?> obtenerCategoria(Future<List<Categoria>> categorias) async {
    List<Categoria> categoriasList = await categorias;
    for (Categoria cat in categoriasList) {
      if (cat.id == categoryId) { // Usa categoryId de la noticia, no el id de la noticia
        return Categoria(nombre:cat.nombre,descripcion:cat.descripcion,imagenUrl:cat.imagenUrl);
      }
    } 
    return null;
  }

  // Método para formato de fecha corta
  String fechaCorta() {
    return '${publicadaEl.day}/${publicadaEl.month}/${publicadaEl.year}';
  }

  // Método para tiempo de lectura formateado
  String tiempoLecturaFormateado() {
    return '$tiempoLectura min${tiempoLectura > 1 ? 's' : ''}';
  }
}