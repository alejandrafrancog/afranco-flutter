import '../domain/task.dart';

class TaskRepository {
  // Lista mutable de tareas
final List<Task> _tasks = List.generate(
  5,
  (index) {
    final fechaLimite = DateTime.now().add(Duration(days: index + 1));
    return Task(
      title: 'Tarea ${index + 1}',
      type: index % 2 == 0 ? 'normal' : 'urgente',
      fechaLimite: fechaLimite,
      pasos: generateSteps('Tarea ${index + 1}', fechaLimite), // Genera pasos con la función reutilizable
    );
  },
);

  static List<String> generateSteps(String title, DateTime fechaLimite) {
  final String fechaFormateada = '${fechaLimite.day.toString().padLeft(2, '0')}/'
      '${fechaLimite.month.toString().padLeft(2, '0')}/'
      '${fechaLimite.year}';
  return [
    'Paso 1: Planificar antes del $fechaFormateada',
    'Paso 2: Ejecutar $title',
    'Paso 3: Revisar $title',
  ];
}


  List<Task> getTasks() {
    return _tasks;
  }

  // Agregar una nueva tarea
 Future<void> addTask(Task task) async {
  await Future.delayed(const Duration(milliseconds: 300)); // Simula una operación asincrónica
  if (!_tasks.contains(task)) { // Verifica que la tarea no exista ya en la lista
    _tasks.add(task);
  }
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