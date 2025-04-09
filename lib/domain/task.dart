// Task entity/model
class Task {
  final String title;
  final String description;
  String? type;
  final DateTime fechaLimite; // Nuevo atributo: Fecha límite
  final List<String> pasos; 

  Task({
    required this.title,
    this.type = 'normal',
    this.description = '',
    required this.fechaLimite, // Requerido
    this.pasos = const [], // Lista vacía por defecto
  });

  // Static list of task types
  static const List<String> taskTypes = ['normal', 'urgente'];
}