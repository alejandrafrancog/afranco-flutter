import 'package:flutter/material.dart';

class AppConstants {
  static const String titleAppBarT = 'Lista de Tareas';
  static const String emptyList = 'No hay tareas';
  static const String taskTypeLabel = 'Tipo';
  static const String pasosTitulo = 'Pasos para completar';
  static const String fechaLimite = 'Fecha Límite';
  static const String titleAppBar = "Mis Tareas"; // Texto base

}
class GameConstants {
  static const String titleApp = 'Mis Juegos'; // Texto base
  static const String welcomeMessage = 'Bienvenido al Juego de Preguntas';
  static const String startGame = 'Iniciar juego';
  static const String finalScore = 'Puntuación final';
  static const String playAgain = 'Jugar de nuevo';
}
class QuoteConstants{
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones disponibles';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 10; // Tamaño de página para paginación
  static const String dateFormat = 'dd/MM/yyyy HH:mm'; 

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