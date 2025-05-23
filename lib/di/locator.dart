import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/data/preferencia_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afranco/data/noticia_repository.dart';

import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());

}
