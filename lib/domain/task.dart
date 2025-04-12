// Task entity/model
class Task {
  final String id;
  final String title;
  final String description;
  String? type;
  final DateTime fechaLimite; // Nuevo atributo: Fecha límite
  final List<String> pasos; 


  Task({
    required this.id,
    required this.title,
    this.type = 'normal',
    this.description = 'This is a random description',
    required this.fechaLimite, // Requerido
    this.pasos = const [], // Lista vacía por defecto
  });
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Task && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;
  // Static list of task types
  static const List<String> taskTypes = ['normal', 'urgente'];
}