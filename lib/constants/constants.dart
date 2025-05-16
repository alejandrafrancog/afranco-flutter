import 'package:flutter/material.dart';
import 'package:afranco/constants/env_constants.dart';
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
class SuccessMessages {
  static String successCreated = 'Noticia/Categoria creada';
  static String successUpdated = 'Noticia/Categoria actualizada';
  static String successDeleted = 'Noticia/Categoria eliminada';

}
class ApiConstants {
  static String get baseUrl => EnvConstants.baseUrl;
  static String errorNotFound = 'No se encontró el recurso';
  static String noticiasEndpoint = 'noticias';
  static String preferenciasEndpoint = 'preferencias';
  static String categoryEndpoint = 'categorias';
  static String comentarioEndpoint = 'categorias';
  static String urlCategorias = '$baseUrl/$categoryEndpoint';
  static String urlNoticias = '$baseUrl/$noticiasEndpoint';
  static String urlPreferencias = '$baseUrl/$preferenciasEndpoint';
  static String comentariosUrl = '$baseUrl/$comentarioEndpoint';
  static var serverError= 'Error del servidor!';

  static var errorTimeout = 'Tiempo de espera agotado';


}
class CategoriaConstants{
  static String errorTimeout = 'Tiempo de espera agotado';
  static String errorNoCategory = 'Categoría no encontrada';
  static String defaultCategoryId = 'sin_categoria';
  static const int timeOutSeconds = 10;
}
class NoticiaConstants {
  static int pageSize = 10;
  static String language = 'es';
  static String category = 'tecnología';
  static int timeOutSeconds = 10;
  static String sinCategoria = "Sin categoría";


  static const List<String> fuentes = [
    'CNN',
    'BBC',
    'New York Times',
    'The Guardian',
    'Reuters',
    'El País',
    'Washington Post',
    'ABC Color',
    'La Nación',
    'Infonegocios',
    'La República',
    'Última Hora',
    'Paraguay.com',
    'Extra',
    'Crónica',
    'Hoy',
    'Infobae',
  ];
  static const String appTitle = 'Noticias Técnicas';
  static const String loadingMessage = 'Cargando noticias...';
  static const String emptyList = 'No hay noticias disponibles';
  static const String errorMessage = 'Error al cargar noticias';
  static const String noMoreNews = 'No hay más noticias disponibles';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm'; 
  static const double spacingHeight = 10; 
 
  static const String etiquetaUltimaActualizacion = 'Última actualización';
  static const String tooltipOrden = 'Cambiar orden';


  
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