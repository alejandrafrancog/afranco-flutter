import 'package:flutter/material.dart';

class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Map<String, dynamic> getErrorMessageAndColor(int? statusCode) {
    String message;
    Color color;

    switch (statusCode) {
      case 400:
        message = 'Solicitud incorrecta. Verifica los datos enviados.';
        color = Colors.orange;
        break;
      case 401:
        message = 'No autorizado. Verifica tus credenciales.';
        color = Colors.red;
        break;
      case 403:
        message = 'Prohibido. No tienes permisos para acceder.';
        color = Colors.redAccent;
        break;
      case 404:
        message = 'Recurso no encontrado. Verifica la URL.';
        color = Colors.blueGrey;
        break;
      case 500:
        message = 'Error interno del servidor. Intenta más tarde.';
        color = Colors.red;
        break;
      default:
        message = 'Ocurrió un error desconocido.';
        color = Colors.grey;
        break;
    }

    return {'message': message, 'color': color};
  }
}