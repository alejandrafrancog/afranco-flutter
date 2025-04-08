// Task entity/model
class Task {
  final String title;
  final String description;
  String? type;

  Task({required this.title, this.type = 'normal', this.description = ''});

  // Static list of task types
  static const List<String> taskTypes = ['normal', 'urgente'];
}
