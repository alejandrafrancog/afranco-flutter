import 'dart:async';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/preferencia.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PreferenciaService extends BaseService {
  // Clave para almacenar el ID en SharedPreferences
  static const String _preferenciaIdKey = 'preferencia_id';
  
  // URL base para las preferencias
  final String _baseUrl = ApiConstants.urlPreferencias;
  
  // ID para preferencias, inicialmente nulo
  String? _preferenciaId;
  
  // Constructor que inicializa el ID desde SharedPreferences
  PreferenciaService() : super() {
    _cargarIdGuardado();
  }
  
  Future<void> _cargarIdGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_preferenciaIdKey)) {
      _preferenciaId = prefs.getString(_preferenciaIdKey);
    } else {
      _preferenciaId = '';
    }
  }
  
  Future<void> _guardarId(String id) async {
    _preferenciaId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferenciaIdKey, id);
  }
  
  /// Obtiene las preferencias del usuario
  Future<Preferencia> getPreferencias() async {
    try {
      debugPrint('📋 Obteniendo preferencias de usuario');
      
      // Si no hay ID almacenado, devolver preferencias vacías sin consultar API
      if (_preferenciaId != null && _preferenciaId!.isNotEmpty) {
        final data = await get(
          '$_baseUrl/$_preferenciaId',
          requireAuthToken: true,
        );
        
        // Si la respuesta es exitosa, convertir a objeto Preferencia
        debugPrint('✅ Preferencias obtenidas correctamente');
        return PreferenciaMapper.fromMap(data);
      }
      
      debugPrint('ℹ️ No hay ID de preferencias guardado, creando uno nuevo');
      return await _crearPreferenciasVacias();
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        // Si no existe, devolver preferencias vacías
        debugPrint('ℹ️ Preferencias no encontradas (404), creando vacías');
        return await _crearPreferenciasVacias();
      } else {
        debugPrint('❌ ApiException en getPreferencias: ${e.message}');
        rethrow;
      }
    } catch (e) {
      debugPrint('❌ Error inesperado en getPreferencias: ${e.toString()}');
      throw ApiException(message: 'Error desconocido: $e', statusCode: 500);
    }
  }
  
  /// Guarda las preferencias del usuario (Actualiza)
  Future<void> guardarPreferencias(Preferencia preferencia) async {
    try {
      debugPrint('💾 Guardando preferencias con ID: $_preferenciaId');
      
      if (_preferenciaId == null || _preferenciaId!.isEmpty) {
        debugPrint('⚠️ No hay ID de preferencia para actualizar, creando uno nuevo');
        await _crearPreferenciasVacias();
      }
      
      await put(
        '$_baseUrl/$_preferenciaId',
        data: preferencia.toJson(),
        requireAuthToken: true,
      );
      
      debugPrint('✅ Preferencias actualizadas con éxito');
    } on ApiException {
      debugPrint('❌ ApiException en guardarPreferencias');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error inesperado en guardarPreferencias: ${e.toString()}');
      throw ApiException(message: 'Error desconocido: $e', statusCode: 500);
    }
  }
  
  /// Método auxiliar para crear un nuevo registro de preferencias vacías
  Future<Preferencia> _crearPreferenciasVacias() async {
    try {
      debugPrint('➕ Creando preferencias vacías');
      
      final preferenciasVacias = Preferencia.empty();
      
      // Crear un nuevo registro en la API
      final data = await post(
        _baseUrl,
        data: preferenciasVacias.toJson(),
        requireAuthToken: true,
      );
      
      // Guardar el nuevo ID
      final nuevoId = data['id'];
      await _guardarId(nuevoId);
      
      debugPrint('✅ Preferencias vacías creadas con éxito, ID: $nuevoId');
      return preferenciasVacias;
    } on ApiException {
      debugPrint('❌ ApiException en _crearPreferenciasVacias');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error inesperado en _crearPreferenciasVacias: ${e.toString()}');
      throw ApiException(message: 'Error desconocido: $e', statusCode: 500);
    }
  }
}
