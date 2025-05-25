import 'dart:async';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/preferencia.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:afranco/core/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaService extends BaseService {
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  // Cambiar a preferenciasEmail
  final String _baseUrl = ApiConstants.urlPreferencias;

  /// Obtiene las preferencias del usuario
  Future<Preferencia> getPreferencias() async {
    try {
      debugPrint('📋 Obteniendo preferencias de usuario');

      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        throw ApiException(message: 'Usuario no autenticado', statusCode: 401);
      }
      debugPrint('👤 Email del usuario: $email');

      try {
        return await obtenerPreferenciaPorEmail(email);
      } on ApiException catch (e) {
        if (e.statusCode == 404) {
          debugPrint('⚠️ No se encontraron preferencias, creando nuevas');
          return await crearPreferencia(email);
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('❌ Error en getPreferencias: ${e.toString()}');
      throw ApiException(message: 'Error: $e', statusCode: 500);
    }
  }

  Future<void> guardarPreferencias(Preferencia preferencia) async {
    try {
      if (preferencia.email.isEmpty) {
        throw ApiException(
          message: 'Email no puede estar vacío',
          statusCode: 400,
        );
      }

      debugPrint('💾 Guardando preferencias:');
      debugPrint('👤 Email: ${preferencia.email}');
      debugPrint('📋 Categorías: ${preferencia.categoriasSeleccionadas}');

      final endpoint = '$_baseUrl/${preferencia.email}';
      debugPrint('🌐 Endpoint: $endpoint');

      final payload = preferencia.toJson();
      
      await put(
        endpoint,
        data: payload,
        requireAuthToken: true,
        errorMessage: 'Error al actualizar preferencias',
      );

      debugPrint('✅ Preferencias actualizadas exitosamente');
    } catch (e) {
      debugPrint('❌ Error en guardarPreferencias: ${e.toString()}');
      throw ApiException(message: 'Error: $e', statusCode: 500);
    }
  }

  Future<Preferencia> crearPreferencia(String email, {List<String>? categorias}) async {
    try {
      debugPrint('➕ Creando preferencias para: $email');

      final preferencia = Preferencia(
        email: email,
        categoriasSeleccionadas: categorias ?? [],
      );

      final response = await post(
        _baseUrl,
        data: preferencia.toJson(),
        requireAuthToken: true,
        errorMessage: 'Error al crear preferencias',
      );

      if (response is String) {
        debugPrint('⚠️ API retornó string, usando preferencia creada');
        return preferencia;
      }

      debugPrint('✅ Preferencias creadas exitosamente');
      return PreferenciaMapper.fromMap(response);
    } catch (e) {
      debugPrint('❌ Error en crearPreferencia: ${e.toString()}');
      throw ApiException(message: 'Error: $e', statusCode: 500);
    }
  }

  Future<Preferencia> obtenerPreferenciaPorEmail(String email) async {
    try {
      debugPrint('🔍 Buscando preferencias para email: $email');
      final endpoint = '$_baseUrl/$email';
      debugPrint('🌐 Endpoint: $endpoint');

      final response = await get(
        endpoint,
        requireAuthToken: true,
        errorMessage: 'Error al obtener preferencias',
      );

      if (response is String) {
        debugPrint('⚠️ API retornó string: $response');
        throw ApiException(
          message: 'Preferencias no encontradas',
          statusCode: 404,
        );
      }

      debugPrint('✅ Preferencias obtenidas correctamente');
      return PreferenciaMapper.fromMap(response);
    } catch (e) {
      debugPrint('❌ Error en obtenerPreferenciaPorEmail: $e');
      rethrow;
    }
  }
}