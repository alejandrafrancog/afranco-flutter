import 'package:dart_mappable/dart_mappable.dart';
part 'preferencia.mapper.dart';
@MappableClass()
class Preferencia with PreferenciaMappable {
  final List<String> categoriasSeleccionadas;
  final String? id;

  Preferencia({required this.categoriasSeleccionadas, this.id});

  // Constructor empty como factory
  @MappableConstructor()
  factory Preferencia.empty() => Preferencia(categoriasSeleccionadas: []);

  

}