import '../domain/task.dart';
import 'package:uuid/uuid.dart';
class TaskRepository {
  static final TaskRepository _instance = TaskRepository._privado();
  
  List<Task> _tasks = [];

  TaskRepository._privado();

  // Factory para acceso global
  factory TaskRepository() => _instance;
  
  List<Task> getTasks() => _tasks;
  TaskRepository._internal() {
  _tasks = List.generate(5, (index) {
    final fechaLimite = DateTime.now().add(Duration(days: index + 1));
    return Task(
      id: const Uuid().v4(), // <<< Genera ID único
      title: 'Tarea ${index + 1}',
      type: index % 2 == 0 ? 'normal' : 'urgente',
      fechaLimite: fechaLimite,
      pasos: generateSteps('Tarea ${index + 1}', fechaLimite),
    );
  });
}
 static List<String> generateSteps(String title, DateTime fecha) {
  return [
    'Paso 1: Planificar $title antes del ${fecha.toString()}', // <<< Usa la fecha real
    'Paso 2: Ejecutar $title',
    'Paso 3: Revisar $title',
  ];
}
  

  // Agregar una nueva tarea
 Future<void> addTask(Task task) async {
  await Future.delayed(const Duration(milliseconds: 300)); // Simula una operación asincrónica
  if (!_tasks.contains(task)) { // Verifica que la tarea no exista ya en la lista
    _tasks.add(task);
  }
}
// En TaskRepository:
Future<void> deleteTaskById(String id) async { // <<< Cambia a ID
  await Future.delayed(const Duration(milliseconds: 300));
  _tasks.removeWhere((task) => task.id == id); // Elimina por ID
}
  // Eliminar una tarea por título
  void deleteTask(String title) {
    _tasks.removeWhere((task) => task.title == title);
  }

  // Eliminar una tarea por índice
 // En TaskRepository
Future<void> deleteTaskByIndex(int index) async {
  await Future.delayed(const Duration(milliseconds: 300)); // Simula async
  if (index >= 0 && index < _tasks.length) {
    _tasks.removeAt(index); // Asegura eliminar por índice
  }
}
  // Actualizar el tipo de una tarea
void updateTaskType(String title, String newType) {
  final task = _tasks.firstWhere(
    (task) => task.title == title,
    orElse: () => Task(
      id: '', // <<< Campo obligatorio pero no se usará
      title: '',
      type: 'normal',
      fechaLimite: DateTime.now(),
      pasos: [],
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