import '../../data/task_repository.dart';
import '../../domain/task.dart';
import '../../data/assistant_repository.dart';


class TaskService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();
  // Obtener todas las tareas
  List<Task> getAllTasks() {
    final tasks = _taskRepository.getTasks();
    print('Operación: Obtener todas las tareas');
    print('Tareas obtenidas: ${tasks.map((task) => task.title).toList()}');
    return tasks;
  }

  // Agregar una nueva tarea con fecha límite y pasos
/*Future<void> addTask(Task task) async {
  // Agrega la tarea al repositorio
  await _taskRepository.addTask(task);
  print('Operación: Agregar tarea');
  print('Tarea agregada: ${task.title}, Tipo: ${task.type}, Fecha límite: ${task.fechaLimite}');
}*/
  Future<void> addTask(String title, String type, DateTime fechaLimite) async {
    final pasos = await _assistantRepository.generateSteps(title, fechaLimite);
    final newTask = Task(
      title: title,
      type: type,
      fechaLimite: fechaLimite,
      pasos: pasos,
    );
    await _taskRepository.addTask(newTask);
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
  Future<List<String>> obtenerPasos(String tituloTarea, DateTime fechaLimite) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula un retraso
    final String fechaFormateada = '${fechaLimite.day.toString().padLeft(2, '0')}/'
        '${fechaLimite.month.toString().padLeft(2, '0')}/'
        '${fechaLimite.year}';
    return [
      'Paso 1: Planificar antes del $fechaFormateada',
      'Paso 2: Ejecutar $tituloTarea',
      'Paso 3: Revisar $tituloTarea',
    ];
  }
  Future<Task> generarTarea(String titulo, DateTime fechaLimite, String tipo) async {
    final pasos = await obtenerPasos(titulo, fechaLimite);
    return Task(
      title: titulo,
      type: tipo,
      fechaLimite: fechaLimite,
      pasos: pasos,
    );
  }
  Future<List<Task>> generarTareas(int cantidad, int inicio) async {
  return Future.wait(
    List.generate(
      cantidad,
      (index) async {
        final taskIndex = inicio + index + 1;
        return await generarTarea(
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