// category.dart
class Category {
  final String? id; 
  final String nombre; 
  final String descripcion; 
  final String imagenUrl; 

  Category({
    this.id, 
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String?, // El ID lo asigna CrudCrud
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      imagenUrl: json['imagenUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
    };
  }
}
