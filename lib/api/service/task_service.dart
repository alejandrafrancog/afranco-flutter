import '../../data/task_repository.dart';
import '../../domain/task.dart';
import '../../data/assistant_repository.dart';
import 'package:uuid/uuid.dart';

class TaskService {
  static final TaskService _instance = TaskService._private(); // Nombre alternativo
  final TaskRepository _taskRepository = TaskRepository();

  // Constructor privado (puedes usar cualquier nombre)
  TaskService._private();

  // Factory para acceder a la instancia
  factory TaskService() => _instance;

  // Métodos existentes...
  List<Task> getAllTasks() => _taskRepository.getTasks();
 
  List<Task> getInitialTasks() {
    return _taskRepository.getTasks(); // Devuelve las 5 tareas generadas
  }
  


  final AssistantRepository _assistantRepository = AssistantRepository();


  Future<void> addTask(String title, String type, DateTime fechaLimite) async {
  final pasos = await _assistantRepository.generateSteps(title, fechaLimite);
  final newTask = Task(
    id: const Uuid().v4(), // <<< Agrega ID
    title: title,
    type: type,
    fechaLimite: fechaLimite,
    pasos: pasos,
  );
  await _taskRepository.addTask(newTask);
}
  Future<void> addTaskDirectly(Task task) async {
  await _taskRepository.addTask(task);
}
  // Eliminar una tarea por título
  void deleteTask(String title) {
    _taskRepository.deleteTask(title);
  
  }

  // Actualizar el tipo de una tarea
  void updateTaskType(String title, String newType) {
    _taskRepository.updateTaskType(title, newType);
  
  } 
  Future<List<String>> obtenerPasos(String tituloTarea, DateTime fechaLimite) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula un retraso
    final String fechaFormateada = '${fechaLimite.day.toString().padLeft(2, '0')}/'
        '${fechaLimite.month.toString().padLeft(2, '0')}/'
        '${fechaLimite.year}';
    
    return TaskRepository.generateSteps(tituloTarea,DateTime(2025,04,10));
  }
Future<Task> generarTarea(String titulo, DateTime fechaLimite, String tipo) async {
  final pasos = await obtenerPasos(titulo, fechaLimite);
  return Task(
    id: const Uuid().v4(),
    title: titulo,
    type: tipo,
    fechaLimite: DateTime(2025,04,10),
    pasos: pasos,
  );
}

// En TaskService:
// En TaskService.generarTareas:
Future<List<Task>> generarTareas(int cantidad, int inicio) async {
  return Future.wait(
    List.generate(
      cantidad,
      (index) async {
        final taskIndex = inicio + index + 1;
        return generarTarea(
          'Tarea $taskIndex',
          DateTime.now().add(Duration(days: taskIndex)),
          taskIndex % 2 == 0 ? 'urgente' : 'normal',
        );
      },
    ),
  );
}

  // Método para obtener pasos simulados según el título de la tarea

}