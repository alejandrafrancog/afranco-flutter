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
