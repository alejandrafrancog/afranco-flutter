import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/task.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter/material.dart';

/// Servicio para gestionar las tareas
class TaskService extends BaseService {
  // Utilizamos el constructor del BaseService
  TaskService() : super();
  Future<List<Task>> obtenerTareasPorUsuario(String usuario) async {
    try {
      // Modificar la URL para usar el formato correcto
      final data = await get(
        '${ApiConstantes.tareasEndpoint}?usuario=$usuario', // Cambiar de /?usuario=$usuario a /$usuario
        errorMessage: 'Error al obtener tareas del usuario',
      );

      if (data is! List) {
        throw ApiException(
          message: 'Formato de respuesta inválido',
          statusCode: 400,
        );
      }

      return data.map((json) => TaskMapper.fromMap(json)).toList();
    } catch (e) {
      debugPrint('❌ Error en obtenerTareasPorUsuario: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Error al obtener tareas por usuario',
        statusCode: null,
      );
    }
  }

  /// Obtiene todas las tareas desde la API
  Future<List<Task>> obtenerTareas() async {
    try {
      // Usamos el método get heredado de BaseService
      final data = await get<List<dynamic>>(
        ApiConstantes.tareasEndpoint,
        errorMessage: 'Error al obtener tareas',
      );

      // Convertimos los datos a objetos Task
      return data.map((json) => TaskMapper.fromMap(json)).toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error al obtener tareas', statusCode: null);
    }
  }

  /// Obtiene una tarea específica por su ID
  Future<Task> obtenerTareaPorId(String id) async {
    try {
      // Usamos el método get heredado de BaseService
      final data = await get<Map<String, dynamic>>(
        '${ApiConstantes.tareasEndpoint}/$id',
        errorMessage: 'Error al obtener la tarea',
      );

      return TaskMapper.fromMap(data);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Error al obtener la tarea',
        statusCode: null,
      );
    }
  }

  /// Crea una nueva tarea
  Future<Task> crearTarea(Task tarea) async {
    try {
      final Map<String, dynamic> tareaData = tarea.toMap();

      // Usar la URL correcta con el usuario
      final response = await post(
        ApiConstantes.tareasEndpoint,
        data: tareaData,
        errorMessage: 'Error al crear la tarea',
      );

      return TaskMapper.fromMap(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error al crear la tarea', statusCode: null);
    }
  }

  /// Actualiza una tarea existente
  Future<Task> actualizarTarea(Task tarea) async {
    if (tarea.id == null) {
      throw ApiException(
        message: 'No se puede actualizar una tarea sin ID',
        statusCode: null,
      );
    }

    try {
      // Usando el método generado por dart_mappable
      final Map<String, dynamic> tareaData = tarea.toMap();

      // Usamos el método put heredado de BaseService
      final response = await put(
        '${ApiConstantes.tareasEndpoint}/${tarea.id}',
        data: tareaData,
        errorMessage: 'Error al actualizar la tarea',
      );

      return TaskMapper.fromMap(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Error al actualizar la tarea',
        statusCode: null,
      );
    }
  }

  /// Elimina una tarea
  Future<void> eliminarTarea(String id) async {
    try {
      // Usamos el método delete heredado de BaseService
      await delete(
        '${ApiConstantes.tareasEndpoint}/$id',
        errorMessage: 'Error al eliminar la tarea',
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Error al eliminar la tarea',
        statusCode: null,
      );
    }
  }

  // CORRECCIÓN 3: Método adicional para crear tarea sin conexión (fallback local)
  Future<Task> crearTareaLocal(Task tarea) async {
    try {
      // Generar un ID temporal si no existe
      if (tarea.id == null) {
        final nuevoId = DateTime.now().millisecondsSinceEpoch.toString();
        tarea = tarea.copyWith(id: nuevoId);
      }

      return tarea;
    } catch (e) {
      throw ApiException(
        message: 'Error al crear la tarea localmente',
        statusCode: null,
      );
    }
  }
}
