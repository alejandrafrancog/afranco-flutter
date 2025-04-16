import '../constants.dart';
import '../domain/noticia.dart';
import 'dart:math';

class NoticiaRepository {
  static final Random _random = Random();
  
  Future<List<Noticia>> getNoticiasPaginadas(int pagina) async {
    // Simula retardo de red
    await Future.delayed(const Duration(seconds: 2));
    
    return List.generate(
      NoticiaConstants.pageSize,
      (index) => _generarNoticia(pagina, index),
    );
  }

  Noticia _generarNoticia(int pagina, int index) {
    // Genera datos únicos y aleatorios
    final id = '${pagina}_$index';
    final fuente = NoticiaConstants.fuentes[_random.nextInt(NoticiaConstants.fuentes.length)];
    final diasAleatorios = _random.nextInt(365);
    
    return Noticia(
      id: id,
      titulo: 'Noticia ${pagina * NoticiaConstants.pageSize + index}',
      fuente: fuente,
      publicadaEl: DateTime.now().subtract(Duration(days: diasAleatorios)),
      descripcion: _generarContenidoAleatorio(),
    );
  }

  String _generarContenidoAleatorio() {
    const palabras = [
      'Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
      'adipiscing', 'elit', 'sed', 'do', 'eiusmod', 'tempor',
      'incididunt', 'ut', 'labore', 'et', 'dolore', 'magna',
      'aliqua', 'ut', 'enim', 'ad', 'minim', 'veniam',
      'quis', 'nostrud', 'exercitation', 'ullamco', 'laboris',
      'nisi', 'ut', 'aliquip', 'ex', 'ea', 'commodo',
      'consequat', 'duis', 'aute', 'irure', 'dolor', 'in',
      'reprehenderit', 'in', 'voluptate', 'velit', 'esse',
      'cillum', 'dolore', 'eu', 'fugiat', 'nulla', 'pariatur',
      'excepteur', 'sint', 'occaecat', 'cupidatat', 'non',
      'proident', 'sunt', 'in', 'culpa', 'qui', 'officia',
      'deserunt', 'mollit', 'anim', 'id', 'est', 'laborum',
      'sed', 'ut', 'perspiciatis', 'unde', 'omnis', 'iste',
      'natus', 'error', 'sit', 'voluptatem', 'accusantium',
      'doloremque', 'laudantium', 'totam', 'rem', 'aperiam',
      'eaque', 'ipsa', 'quae', 'ab', 'illo', 'inventore',
      'veritatis', 'et', 'quasi', 'architecto', 'beatae',
      'vitae', 'dicta', 'sunt', 'explicabo', 'nemo', 'enim',
      'ipsam', 'voluptatem', 'quia', 'dolor', 'sit', 'amet',
      'consectetur', 'adipisci', 'velit', 'sed', 'quia',
      'non', 'numquam', 'eiusmod', 'tempor', 'incididunt',
      'ut', 'labore', 'et', 'dolore', 'magna', 'aliqua',
      'ut', 'enim', 'ad', 'minim', 'veniam', 'quis',
      'nostrud', 'exercitation', 'ullamco', 'laboris',
        
      ];
    
    return List.generate(50, (_) => palabras[_random.nextInt(palabras.length)]).join(' ');
  }
}