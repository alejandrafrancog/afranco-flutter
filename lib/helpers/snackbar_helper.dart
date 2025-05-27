import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, String message, {int? statusCode}) {
    final color = _getSnackBarColor(statusCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 200);
  }

  // Nuevo método para errores del cliente (400-499)
  static void showClientError(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 400);
  }
     
  // Nuevo método para errores del servidor (500+)
  static void showServerError(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 500);
  }

  // Nuevos métodos para las operaciones CRUD
  static void showLoadSuccess(BuildContext context, int count) {
    showSuccess(context, 'Se cargaron $count noticias correctamente');
  }

  static void showEditSuccess(BuildContext context) {
    showSuccess(context, 'Noticia editada correctamente');
  }

  static void showDeleteSuccess(BuildContext context) {
    showSuccess(context, 'Noticia eliminada correctamente');
  }

  static void showCreateSuccess(BuildContext context) {
    showSuccess(context, 'Noticia creada correctamente');
  }

  static void showRefreshSuccess(BuildContext context, int count) {
    showSuccess(context, 'Lista actualizada - $count noticias');
  }

  static Color _getSnackBarColor(int? statusCode) {
    if (statusCode == null) {
      return Colors.grey; // Color por defecto
    } else if (statusCode >= 200 && statusCode < 300) {
      return Colors.green; // Éxito
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orange; // Error del cliente
    } else if (statusCode >= 500) {
      return Colors.red; // Error del servidor
    }
    return Colors.grey; // Color por defecto
  }
}