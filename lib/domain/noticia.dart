import 'dart:math';
class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final int tiempoLectura; 
  final DateTime publicadaEl;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
  
  }):tiempoLectura  = _generarTiempoLectura();
  
  static int _generarTiempoLectura() {
    final random = Random();
    return random.nextInt(10) + 1; // 1-10
  }
}