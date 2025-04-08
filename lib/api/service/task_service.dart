import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();

  // Obtener todas las tareas
  List<Task> getAllTasks() {
    final tasks = _taskRepository.getTasks();
    print('Operación: Obtener todas las tareas');
    print('Tareas obtenidas: ${tasks.map((task) => task.title).toList()}');
    return tasks;
  }

  // Agregar una nueva tarea con fecha límite y pasos
  Future<void> addTask(String title, {String type = 'normal'}) async {
    final fechaLimite = DateTime.now().add(Duration(days: 7)); // Fecha límite: 7 días desde hoy
    final pasos = await obtenerPasos(title); // Obtiene los pasos simulados
    final newTask = Task(
      title: title,
      type: type,
      fechaLimite: fechaLimite,
      pasos: pasos,
    );
    await _taskRepository.addTask(newTask);
    print('Operación: Agregar tarea');
    print('Tarea agregada: ${newTask.title}, Tipo: ${newTask.type}, Fecha límite: ${newTask.fechaLimite}');
  }

  // Eliminar una tarea por título
  void deleteTask(String title) {
    _taskRepository.deleteTask(title);
    print('Operación: Eliminar tarea');
    print('Tarea eliminada: $title');
  }

  // Actualizar el tipo de una tarea
  void updateTaskType(String title, String newType) {
    _taskRepository.updateTaskType(title, newType);
    print('Operación: Actualizar tarea');
    print('Tarea actualizada: $title, Nuevo tipo: $newType');
  }

  // Método para obtener pasos simulados según el título de la tarea
  Future<List<String>> obtenerPasos(String tituloTarea) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula un retraso
    return [
      'Paso 1: Planificar $tituloTarea',
      'Paso 2: Ejecutar $tituloTarea',
      'Paso 3: Revisar $tituloTarea',
    ];
  }
}