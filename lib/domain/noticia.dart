import 'dart:math';

class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final String imagen; // Nuevo campo para la imagen
  final int tiempoLectura;
  final DateTime publicadaEl;
  final String url; // Campo adicional para el enlace original

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.imagen,
    required this.publicadaEl,
    required this.url,
  }) : tiempoLectura = _generarTiempoLectura();

  static int _generarTiempoLectura() {
    final random = Random();
    return random.nextInt(10) + 1; // 1-10 minutos
  }

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _limpiarTexto(json['title']) ?? 'Sin título',
      descripcion: _limpiarTexto(json['description']) ?? 'Sin descripción',
      fuente: _limpiarTexto(json['source']['name']) ?? 'Fuente desconocida',
      imagen: _validarImagen(json['image']),
      publicadaEl: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      url: json['url'] ?? '',
    );
  }

  static String? _limpiarTexto(String? texto) {
    if (texto == null) return null;
    return texto
        .replaceAll(RegExp(r'\n+'), '\n')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // Validar URL de imagen
  static String _validarImagen(dynamic imagen) {
    if (imagen is! String || imagen.isEmpty) {
      return 'https://via.placeholder.com/150'; // Imagen por defecto
    }
    try {
      final uri = Uri.parse(imagen);
      return uri.isAbsolute ? imagen : 'https://via.placeholder.com/150';
    } catch (_) {
      return 'https://via.placeholder.com/150';
    }
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