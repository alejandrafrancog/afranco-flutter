import 'package:dart_mappable/dart_mappable.dart';
import 'package:afranco/domain/task.dart';

part 'task_cache_prefs.mapper.dart';

/// Modelo para guardar las tareas en caché por usuario
/// 
/// Este modelo se utiliza para almacenar en SharedPreferences las tareas
/// correspondientes a cada usuario, identificadas por su email.
@MappableClass()
class TaskCachePrefs with TaskCachePrefsMappable {
  /// Email que identifica al usuario dueño de las tareas
  final String usuario;
  
  /// Lista de tareas del usuario
  final List<Task> misTareas;

  const TaskCachePrefs({
    required this.usuario,
    required this.misTareas,
  });
  
}