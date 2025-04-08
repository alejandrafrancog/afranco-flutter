import '../domain/task.dart';

class TaskRepository {
  // Lista mutable de tareas
  final List<Task> _tasks = [
    Task(title: 'Tarea 1'),
    Task(title: 'Tarea 2',type:'urgente'),
    Task(title: 'Tarea 3'),
    Task(title: 'Tarea 4', type:'urgente'), // Por defecto será 'normal'
    Task(title: 'Tarea 5'), // Por defecto será 'normal'
    Task(title:'Tarea 6', type: 'urgente'),
    Task(title: 'Tarea 7', type: 'normal'), 
    Task(title:'Tarea 8', type: 'urgente'),
    Task(title:'Tarea 9'),
    Task(title:'Tarea 10', type: 'urgente'),

  ];

  // Obtener todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }
  

  // Agregar una nueva tarea
  /*void addTask(Task task) {
    _tasks.add(task);
  }*/
    Future<void> addTask(Task task) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.add(task);
  }

  // Eliminar una tarea por título
  void deleteTask(String title) {
    _tasks.removeWhere((task) => task.title == title);
  }
    Future<void> deleteTaskByIndex(int index) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }

  // Actualizar el tipo de una tarea
  void updateTaskType(String title, String newType) {
    final task = _tasks.firstWhere((task) => task.title == title, orElse: () => Task(title: ''));
    if (task.title.isNotEmpty) {
      task.type = newType;
    }
  }
  Future<void> updateTask(int index, Task updatedTask) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }
}