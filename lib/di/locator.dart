import 'package:afranco/api/service/comentario_service.dart';
import 'package:afranco/api/service/noticia_service.dart';
import 'package:afranco/api/service/preferencia_service.dart';
import 'package:afranco/api/service/reporte_service.dart';
import 'package:afranco/core/category_cache_service.dart';
import 'package:afranco/core/comentario_cache_service.dart';
import 'package:afranco/core/connectivity_service.dart';
import 'package:afranco/core/reporte_cache_service.dart';
import 'package:afranco/core/secure_storage_service.dart';
import 'package:afranco/core/service/shared_preferences_service.dart';
import 'package:afranco/data/auth_repository.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/data/comentario_repository.dart';
import 'package:afranco/data/preferencia_repository.dart';
import 'package:afranco/data/reporte_repository.dart';
import 'package:afranco/data/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afranco/data/noticia_repository.dart';

import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  // 1. Servicios base SIN dependencias
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<SecureStorageService>(SecureStorageService());
  di.registerSingleton<SharedPreferencesService>(SharedPreferencesService());

  // 2. Repositorios (mover antes de los servicios que los usan)
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<CategoriaRepository>(() => CategoriaRepository());
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerLazySingleton<ReporteRepository>(() => ReporteRepository());
  di.registerLazySingleton<TaskRepository>(() => TaskRepository());

  // 3. Servicios que dependen de los repositorios
  di.registerSingleton<ComentarioCacheService>(ComentarioCacheService());
    di.registerLazySingleton<ComentarioService>(() => ComentarioService());

  di.registerSingleton<CategoryCacheService>(CategoryCacheService());
  di.registerSingleton<ReporteCacheService>(ReporteCacheService());
  di.registerSingleton<ConnectivityService>(ConnectivityService());
  di.registerSingleton<PreferenciaService>(PreferenciaService());
  di.registerSingleton<ReporteService>(ReporteService());
  di.registerSingleton<NoticiaService>(NoticiaService());
}
