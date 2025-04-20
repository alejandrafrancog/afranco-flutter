import 'package:afranco/constants.dart';
import 'package:afranco/domain/noticia.dart';
import 'dart:math';

class NoticiaRepository {
  static final Random _random = Random();
 
  final _titulosPosibles = [
  "Se reeligió al presidente en una ajustada votación",
  "Nueva ley de educación entra en vigor",
  "Descubren nueva especie en el Chaco paraguayo",
  "La inflación baja por tercer mes consecutivo",
  "Paraguay lanza programa de reciclaje nacional",
  "Corte Suprema emite fallo histórico",
  "Comienza la construcción del puente bioceánico",
  "Científicos paraguayos logran avance médico",
  "Estudiantes protestan frente al Congreso",
  "Inauguran nuevo hospital regional en el interior",
  "Tecnología blockchain será adoptada por bancos locales",
  "Paraguay firma acuerdo comercial con la UE",
  "Paraguay lanza campaña de vacunación masiva",
  "Paraguay se une a la iniciativa de reforestación global",
  "Paraguay recibe premio por su gestión ambiental",
  "Paraguay lanza programa de becas para estudiantes",
  "Paraguay se convierte en líder en energías renovables",
  "Paraguay celebra el Día de la Independencia con desfiles",
  "Paraguay lanza programa de alfabetización digital",
  "Paraguay recibe inversión extranjera récord",
  "Paraguay lanza programa de apoyo a emprendedores",
  "Paraguay se une a la lucha contra el cambio climático",
  
];

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
    final titulo = _titulosPosibles[_random.nextInt(_titulosPosibles.length)];
    
    return Noticia(
      id: id,
      titulo:titulo,
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