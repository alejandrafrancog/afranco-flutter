import 'package:afranco/api/service/categoria_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afranco/api/service/noticia_repository.dart';

import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());

}
