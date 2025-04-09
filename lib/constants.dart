import 'package:flutter/material.dart';

class AppConstants {
  static const String TITLE_APPBAR = 'Lista de Tareas';
  static const String EMPTY_LIST = 'No hay tareas';
  static const String TASK_TYPE_LABEL = 'Tipo';
  static const String PASOS_TITULO = 'Pasos para completar';
  static const String FECHA_LIMITE = 'Fecha Límite';
}
class AppStyles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size(200, 45), // Ancho máximo (responsive),
   
    backgroundColor: Colors.white,
    foregroundColor: Colors.teal,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(150),
    ),
  );

  // Ejemplo de otro estilo reutilizable:
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}