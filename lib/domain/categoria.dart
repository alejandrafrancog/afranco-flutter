import 'package:dart_mappable/dart_mappable.dart';

part 'categoria.mapper.dart';

@MappableClass()
class Categoria with CategoriaMappable {
  final String? id; 
  final String nombre; 
  final String descripcion; 
  final String imagenUrl; 

  Categoria({
    this.id, 
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });
}
