import 'package:afranco/core/api_config.dart';

class AppConstantes {
  static const String titleAppBarT = 'Lista de Tareas';
  static const String emptyList = 'No hay tareas';
  static const String taskTypeLabel = 'Tipo';
  static const String titleAppBar = "Mis Tareas"; // Texto base
  static const int timeoutSeconds = 60;
  static const String errorCargarTareas = 'Error al cargar las tareas';
  static const String idCategoriaInvalido = 'ID de categoría inválido';
  static const double espaciadoAlto = 10;
  static const String errorTimeOut = 'Tiempo de espera agotado';
  static const String errorUnauthorized = 'Se requiere autenticación'; //
  static const String errorGenerico = 'Error al procesar la solicitud'; //
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
  static const String cacheTareasKey = 'tarea_cache_prefs';
  static const String errorObtenerTareasPorUsuario ='Error al obtener tareas del usuario';
  static const String errorObtenerTareas = 'Error al obtener tareas';
  static const String errorAgregarTarea = 'Error al agregar tarea';
  static const String errorEliminarTarea = 'Error al eliminar tarea';
  static const String errorActualizarTarea = 'Error al actualizar tarea';
  static const String tituloVacio = 'El título no puede estar vacío';
}


class ValidacionConstantes {
  // Mensajes genéricos
  static const String campoVacio = ' no puede estar vacío';  // Campos comunes
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
  static const String errorServer = 'Error del servidor en preferencia';
  static const String errorUnauthorized =
      'No autorizado para acceder a preferencia';
  static const String errorInvalidData = 'Datos inválidos en preferencia';
  static const String errorNotFound = 'Preferencia no encontrada';
}

class GameConstants {
  static const String titleApp = 'Mis Juegos'; // Texto base
  static const String welcomeMessage = 'Bienvenido al Juego de Preguntas';
  static const String startGame = 'Iniciar juego';
  static const String finalScore = 'Puntuación final';
  static const String playAgain = 'Jugar de nuevo';
}

class QuoteConstants {
  static const int pageSize = 10; // Tamaño de página para paginación
}

class ApiConstants {
  static String get baseUrl => ApiConfig.beeceptorBaseUrl;
  static String noticiasEndpoint = 'noticias';
  static String preferenciasEndpoint = 'preferenciasEmail';
  static String categoryEndpoint = 'categorias';
  static String urlCategorias = '$baseUrl/$categoryEndpoint';
  static String urlNoticias = '$baseUrl/$noticiasEndpoint';
  static String urlPreferencias = '$baseUrl/$preferenciasEndpoint';
  static String errorNoInternet = 'No hay conexión a Internet';
}

class AuthConstants {
  static const errorAutenticacion = 'Error de autenticación';
  static const errorCredencialesInvalidas = 'Usuario o contraseña incorrectos';
  static const errorServidorAuth = 'Error en el servidor de autenticación';
}

class ReporteConstantes {
  static const String errorCrearReporte = 'Error al crear el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
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
  static const String errorNotFound = 'Comentario no encontrado';
  static const String successSubcomentario =
      'Subcomentario agregado exitosamente';
  static const String errorServer = 'Error del servidor en comentario';
  static const String mensajeError = 'Error al obtener comentarios';
  static const String errorUnauthorized =
      'No autorizado para acceder a comentario';
  static const String errorInvalidData = 'Datos inválidos en comentario';
}

class CategoriaConstants {
  static String sinCategoria = 'Sin categoría';
  static const int timeOutSeconds = 10;
  static String errorNoCategoria = 'Categoría no encontrada';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String errorUpdated = 'Error al editar la categoría';
  static const String errorUnauthorized =
      'No autorizado para acceder a categoría';
  static const String errorInvalidData = 'Datos inválidos en categoria';
  static const String errorServer = 'Error del servidor en categoria';
}

class NoticiaConstants {
  static int pageSize = 10;
  static int timeOutSeconds = 10;
  static const String errorObtenerNoticia = 'Error al obtener la noticia';

  static const String appTitle = 'Noticias';
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
  static const String errorUnauthorized =
      'No autorizado para acceder a noticia';
  static const String errorNotFound = 'Noticia no encontrada';
  // Mensajes de error específicos de operaciones
  static const errorGenerico = 'Error al procesar las noticias';
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
  static const String idNoticia = 'ID de la noticia';
}

