import 'package:flutter/foundation.dart';
import 'package:afranco/domain/noticia.dart';

class NoticiaCacheService {
  static final NoticiaCacheService _instance = NoticiaCacheService._internal();
  final Map<String, Noticia> _noticiasCache = {};
  
  factory NoticiaCacheService() => _instance;
  NoticiaCacheService._internal();

  Future<void> updateNoticia(Noticia noticia) async {
    debugPrint('🔄 Actualizando caché para noticia: ${noticia.id}');
    _noticiasCache[noticia.id ?? ''] = noticia;
  }

  Future<void> deleteNoticia(String id) async {
    debugPrint('🗑️ Eliminando noticia del caché: $id');
    _noticiasCache.remove(id);
  }

  Future<void> addNoticia(Noticia noticia) async {
    debugPrint('➕ Agregando noticia al caché: ${noticia.id}');
    _noticiasCache[noticia.id ?? ''] = noticia;
  }

  Future<Noticia?> getNoticia(String id) async {
    return _noticiasCache[id];
  }

  void invalidateCache() {
    debugPrint('🔄 Invalidando caché de noticias');
    _noticiasCache.clear();
  }
}