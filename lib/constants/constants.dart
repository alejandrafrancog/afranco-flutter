import 'package:afranco/core/api_config.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String titleAppBarT = 'Lista de Tareas';
  static const String emptyList = 'No hay tareas';
  static const String taskTypeLabel = 'Tipo';
  static const String pasosTitulo = 'Pasos para completar';
  static const String fechaLimite = 'Fecha Límite';
  static const String titleAppBar = "Mis Tareas"; // Texto base
}

class AppConstantes {
  static const int timeoutSeconds = 60;
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int pageSize = 10;
  static const double espaciadoAlto = 10;
  static const String errorTimeOut = 'Tiempo de espera agotado';
  static const String usuarioDefault = 'Usuario anonimo';
  static const String errorServer = 'Error del servidor'; //
  static const String errorUnauthorized = 'Se requiere autenticación'; //
  static const String errorNoInternet = 'Sin conexión a Internet'; //
  static const String errorInvalidData = 'Datos inválidos'; //
  static const String tokenNoEncontrado =
      'No se encontró el token de autenticación';
  static const String errorDeleteDefault = 'Error al eliminar el recurso';
  static const String errorUpdateDefault = 'Error al actualizar el recurso';
  static const String errorCreateDefault = 'Error al crear el recurso';
  static const String errorGetDefault = 'Error al obtener el recurso';
  static const String errorAccesoDenegado =
      'Acceso denegado. Verifique su API key o IP autorizada';
  static const String limiteAlcanzado =
      'Límite de peticiones alcanzado. Intente más tarde';
  static const String errorServidorMock =
      'Error en la configuración del servidor mock';
  static const String errorConexionProxy =
      'Error de conexión con el servidor proxy';
  static const String conexionInterrumpida = 'La conexión fue interrumpida';
  static const String errorRecuperarRecursos =
      'Error al recuperar recursos del servidor';
  static const String errorCriticoServidor = 'Error crítico en el servidor';
  static const String notUser = 'No hay usuario autenticado';
  static const String errorCache = 'Error al actualizar caché local';
}

class TareasConstantes {
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  static const String tipoTarea = 'Tipo: ';
  static const String taskTypeNormal = 'normal';
  static const String taskTypeUrgent = 'urgente';
  static const String taskDescription = 'Descripción: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  static const String fechaLimite = 'Fecha límite: ';
  static const String tareaEliminada = 'Tarea eliminada';
  static const int limitePasos = 2;
  static const int limiteTareas = 10;
  // Constantes para cache y persistencia
  static const String cacheTareasKey = 'tarea_cache_prefs';
  // Mensajes de error
  static const String errorObtenerTareasPorUsuario =
      'Error al obtener tareas del usuario';
  static const String errorObtenerTareas = 'Error al obtener tareas';
  static const String errorAgregarTarea = 'Error al agregar tarea';
  static const String errorEliminarTarea = 'Error al eliminar tarea';
  static const String errorActualizarTarea = 'Error al actualizar tarea';
  static const String tituloVacio = 'El título no puede estar vacío';
}

class ValidacionConstantes {
  // Mensajes genéricos
  static const String campoVacio = ' no puede estar vacío';
  static const String noFuturo = ' no puede estar en el futuro.';
  // static const String campoInvalido = 'no es válido';
  // static const String campoMuyCorto = 'es demasiado corto';
  // static const String campoMuyLargo = 'es demasiado largo';

  // Campos comunes
  static const String imagenUrl = 'URL de la imagen';

  static const String nombreCategoria = 'El nombre de la categoría';
  static const String descripcionCategoria = 'La descripción de la categoría';
  static const String tituloNoticia = 'El título de la noticia';
  static const String descripcionNoticia = 'La descripción de la noticia';
  static const String fuenteNoticia = 'La fuente de la noticia';
  static const String fechaNoticia = 'La fecha de la publicación de la noticia';
}

class ApiConstantes {
  static const String categoriaEndpoint = '/categorias';
  static const String noticiasEndpoint = '/noticias';
  static const String preferenciasEndpoint = '/preferenciasEmail';
  static const String comentariosEndpoint = '/comentarios';
  static const String reportesEndpoint = '/reportes';
  static const String loginEndpoint = '/login';
  static const String tareasEndpoint = '/tareas';
}

class PreferenciaConstantes {
  static const String mensajeError = 'Error al obtener categorías';
  static const String errorUpdated = 'Error al guardar preferencias';
  static const String errorCreated = 'Error al crear la preferencia';
  static const String errorServer = 'Error del servidor en preferencia';
  static const String errorUnauthorized =
      'No autorizado para acceder a preferencia';
  static const String errorInvalidData = 'Datos inválidos en preferencia';
  static const String errorNotFound = 'Preferencia no encontrada';
  static const String errorInit = 'Error al inicializar preferencias';
}

class GameConstants {
  static const String titleApp = 'Mis Juegos'; // Texto base
  static const String welcomeMessage = 'Bienvenido al Juego de Preguntas';
  static const String startGame = 'Iniciar juego';
  static const String finalScore = 'Puntuación final';
  static const String playAgain = 'Jugar de nuevo';
}

class QuoteConstants {
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
  static String get baseUrl => ApiConfig.beeceptorBaseUrl;
  static String errorNotFound = 'No se encontró el recurso';
  static String noticiasEndpoint = 'noticias';
  static String tareasEndpoint = 'tareasPreferencias';

  static String preferenciasEndpoint = 'preferenciasEmail';
  static String categoryEndpoint = 'categorias';
  static String comentarioEndpoint = 'comentarios';
  static String urlCategorias = '$baseUrl/$categoryEndpoint';
  static String urlNoticias = '$baseUrl/$noticiasEndpoint';
  static String urlPreferencias = '$baseUrl/$preferenciasEndpoint';
  static String comentariosUrl = '$baseUrl/$comentarioEndpoint';
  static String urlTareas = '$baseUrl/$tareasEndpoint';

  static var serverError = 'Error del servidor!';
  static int timeoutSeconds = 10;
  static var errorTimeout = 'Tiempo de espera agotado';

  static String errorNoInternet = 'No hay conexión a Internet';

  static var errorUnauthorized = "No autorizado";
}

class AuthConstants {
  static const errorAutenticacion = 'Error de autenticación';
  static const errorCredencialesInvalidas = 'Usuario o contraseña incorrectos';
  static const errorServidorAuth = 'Error en el servidor de autenticación';
}

class ReporteConstantes {
  static const String reporteCreado = 'Reporte enviado con éxito';
  static const String noticiaNoExiste = 'La noticia reportada no existe';
  static const String errorCrearReporte = 'Error al crear el reporte';
  static const String errorObtenerReporte = 'Error al obtener el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
  static const String listaVacia = 'No hay reportes disponibles';
  static const String mensajeCargando = 'Cargando reportes...';
  static const String errorUnauthorized =
      'No autorizado para acceder a reporte';
  static const errorActualizarReporte = 'Error al actualizar el reporte';
  static const errorObtenerPorNoticia =
      'Error al obtener reportes de la noticia';
  static const errorFormatoInvalido = 'Formato de reporte inválido';
  static const String errorInvalidData = 'Datos inválidos en reporte';
  static const String errorServer = 'Error del servidor en reporte';
  static const errorEliminarReporte = 'Error al eliminar el reporte';
  static const errorEliminarReportes = 'Error al eliminar el reporte';

  static const String errorNotFound = 'Reporte no encontrado';
}

class ComentarioConstantes {
  static const String mensajeCargando = 'Cargando comentarios...';
  static const String listaVacia = 'No hay comentarios disponibles';
  static const String errorNotFound = 'Comentario no encontrado';
  static const String successCreated = 'Comentario agregado exitosamente';
  static const String successReaction = 'Reacción registrada exitosamente';
  static const String successSubcomentario =
      'Subcomentario agregado exitosamente';
  static const String errorServer = 'Error del servidor en comentario';
  static const String mensajeError = 'Error al obtener comentarios';
  static const String errorUnauthorized =
      'No autorizado para acceder a comentario';
  static const String errorInvalidData = 'Datos inválidos en comentario';
}

class CategoriaConstants {
  static String errorTimeout = 'Tiempo de espera agotado';
  static String errorNoCategory = 'Categoría no encontrada';
  static String defaultCategoryId = 'sin_categoria';
  static String sinCategoria = 'Sin categoría';
  static const int timeOutSeconds = 10;
  static String errorNoCategoria = 'Categoría no encontrada';
  static const String defaultcategoriaId = 'Sin Categoria';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String errorUpdated = 'Error al editar la categoría';
  static const String successDeleted = 'Categoria eliminada exitosamente';
  static const String errorDelete = 'Error al eliminar la categoría';
  static const String errorAdd = 'Error al agregar categoría';
  static const String successCreated = 'Categoria creada exitosamente';
  static const String errorCreated = 'Error al crear la categoría';
  static const String errorUnauthorized =
      'No autorizado para acceder a categoría';
  static const String errorInvalidData = 'Datos inválidos en categoria';
  static const String errorServer = 'Error del servidor en categoria';
}

class NoticiaConstants {
  static int pageSize = 10;
  static String language = 'es';
  static String category = 'tecnología';
  static int timeOutSeconds = 10;
  static String sinCategoria = "Sin categoría";
  static const String errorObtenerNoticia = 'Error al obtener la noticia';

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
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
  static const String errorUnauthorized =
      'No autorizado para acceder a noticia';
  static const String errorNotFound = 'Noticia no encontrada';
  // Mensajes de error específicos de operaciones
  static const errorPaginaInvalida = 'Número de página inválido';
  static const errorGenerico = 'Error al procesar las noticias';
  static const errorObtenerNoticias = 'Error al obtener las noticias';
  static const errorFormatoInvalido = 'Formato de respuesta inválido';
  static const errorCrearNoticia = 'Error al crear la noticia';
  static const errorActualizarNoticia = 'Error al actualizar la noticia';
  static const errorObtenerNoticiasTecno =
      'Error al obtener noticias tecnológicas';
  static const errorEliminarNoticia = 'Error al eliminar la noticia';
  static const errorActualizacionCompleta =
      'Error al actualizar la noticia completa';
  static const String errorInvalidData = 'Datos inválidos en noticia';
  static const String errorServer = 'Error del servidor en noticia';
  static const String errorCreated = 'Error al crear la noticia';
  static const String errorUpdated = 'Error al editar la noticia';
  static const String errorDelete = 'Error al eliminar la noticia';
  static const String errorFilter = "Error al filtrar noticias";
  static const String etiquetaUltimaActualizacion = 'Última actualización';
  static const String tooltipOrden = 'Cambiar orden';
}

class AppStyles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size(200, 45), // Ancho máximo (responsive),

    backgroundColor: Colors.white,
    foregroundColor: Colors.teal,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
  );

  // Ejemplo de otro estilo reutilizable:
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}
