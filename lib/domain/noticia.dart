import 'dart:math';

class Noticia {
  final String id;
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
    required this.titulo,
    required this.fuente,
    required this.imagen,
    required this.publicadaEl,
    required this.descripcion,
    required this.url,
    this.autor,
    this.contenido,
  }) : tiempoLectura = _generarTiempoLectura();

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



  // Método para formato de fecha corta
  String fechaCorta() {
    return '${publicadaEl.day}/${publicadaEl.month}/${publicadaEl.year}';
  }

  // Método para tiempo de lectura formateado
  String tiempoLecturaFormateado() {
    return '$tiempoLectura min${tiempoLectura > 1 ? 's' : ''}';
  }
}