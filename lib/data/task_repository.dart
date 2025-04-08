import '../domain/task.dart';

class TaskRepository {
  // Lista mutable de tareas
  final List<Task> _tasks = List.generate(
    10,
    (index) => Task(
      title: 'Tarea ${index + 1}',
      type: index % 2 == 0 ? 'normal' : 'urgente', // Alterna entre 'normal' y 'urgente'
      fechaLimite: DateTime.now().add(Duration(days: index + 1)), // Fecha límite dinámica
      pasos: [
        'Paso 1: Planificar Tarea ${index + 1}',
        'Paso 2: Ejecutar Tarea ${index + 1}',
        'Paso 3: Revisar Tarea ${index + 1}',
      ], // Pasos simulados
    ),
  );

  // Obtener todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }

  // Agregar una nueva tarea
  Future<void> addTask(Task task) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.add(task);
  }

  // Eliminar una tarea por título
  void deleteTask(String title) {
    _tasks.removeWhere((task) => task.title == title);
  }

  // Eliminar una tarea por índice
  Future<void> deleteTaskByIndex(int index) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }

  // Actualizar el tipo de una tarea
  void updateTaskType(String title, String newType) {
    final task = _tasks.firstWhere(
      (task) => task.title == title,
      orElse: () => Task(
        title: '',
        type: 'normal',
        fechaLimite: DateTime.now(), // Fecha límite predeterminada
        pasos: [], // Lista de pasos vacía
      ),
    );
    if (task.title.isNotEmpty) {
      task.type = newType;
    }
  }

  // Actualizar una tarea por índice
  Future<void> updateTask(int index, Task updatedTask) async {
    // Simula una operación asincrónica
    await Future.delayed(const Duration(milliseconds: 300));
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }
}