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

  // Agregar una nueva tarea
  void addTask(String title, {String type = 'normal'}) {
    final newTask = Task(title: title, type: type);
    _taskRepository.addTask(newTask);
    print('Operación: Agregar tarea');
    print('Tarea agregada: ${newTask.title}, Tipo: ${newTask.type}');
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
}