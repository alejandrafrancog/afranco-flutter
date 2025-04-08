import '../domain/task.dart';

class TaskRepository {
  // Lista mutable de tareas
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'urgente'),
    Task(title: 'Tarea 2'),
    Task(title: 'Tarea 3', type: 'urgente'),
    Task(title: 'Tarea 4'), // Por defecto será 'normal'
    Task(title: 'Tarea 5'), // Por defecto será 'normal'
    Task(title:'Tarea 6', type: 'urgente'),
    Task(title: 'Tarea 7', type: 'normal'), 
    Task(title:'Tarea 8', type: 'urgente'),
    Task(title: 'Tarea 8', type: 'normal'), 
    Task(title:'Tarea 10', type: 'urgente'),
    Task(title: 'Tarea 11', type: 'normal'), 
  ];

  // Obtener todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }

  // Agregar una nueva tarea
  void addTask(Task task) {
    _tasks.add(task);
  }

  // Eliminar una tarea por título
  void deleteTask(String title) {
    _tasks.removeWhere((task) => task.title == title);
  }

  // Actualizar el tipo de una tarea
  void updateTaskType(String title, String newType) {
    final task = _tasks.firstWhere((task) => task.title == title, orElse: () => Task(title: ''));
    if (task.title.isNotEmpty) {
      task.type = newType;
    }
  }
}