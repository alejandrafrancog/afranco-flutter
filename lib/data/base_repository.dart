import 'package:afranco/constants/constants.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:flutter/foundation.dart';

abstract class BaseRepository {
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on ApiException catch (e) {
      // Relanza las excepciones conocidas
      debugPrint(e.message);
      rethrow;
    } catch (e) {
      // Convierte excepciones genéricas en ApiException
      throw ApiException(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  void validarNoVacio(String? valor, String nombreCampo) {
    if (valor == null || valor.isEmpty) {
      throw ApiException(
        message: '$nombreCampo${ValidacionConstantes.campoVacio}',
        statusCode: 400,
      );
    }
  }

  Future<R> manejarExcepcion<R>(
    Future<R> Function() accion, {
    String mensajeError = 'Error desconocido',
  }) async {
    try {
      return await accion();
    } catch (e) {
      if (e is ApiException) {
        // Propagar ApiException directamente
        rethrow;
      } else {
        // Envolver otras excepciones en ApiException con mensaje contextual
        throw ApiException(message:'$mensajeError: $e',statusCode: null);
      }
    }
  }

  /// Valida que un ID no esté vacío.
  void validarId(String? id) {
    validarNoVacio(id, 'ID');
  }

  void checkForEmpty(List<MapEntry<String, dynamic>> fields) {
    for (final field in fields) {
      if (field.value == null || field.value.toString().isEmpty) {
        throw ApiException(
          message: 'El campo ${field.key} no puede estar vacío',
          statusCode: 400,
        );
      }
    }
  }
}
