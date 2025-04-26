// category.dart
class Categoria {
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

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['_id'] as String?, // El ID lo asigna CrudCrud
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      imagenUrl: json['imagenUrl'] as String,
    );
  }

static Future<String> getCategoryName(String id, Future<List<Categoria>> categoriasFuture) async {
  try {
    final categorias = await categoriasFuture;
    final categoria = categorias.firstWhere(
      (c) => c.id == id,
      orElse: () => Categoria(
        nombre: 'Sin categoría',
        descripcion: '',
        imagenUrl: '',
      ),
    );
    return categoria.nombre;
  } catch (e) {
    return 'Error al cargar categoría';
  }
}
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
    };
  }
}
