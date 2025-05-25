import 'package:afranco/core/category_cache_service.dart';
import 'package:afranco/domain/categoria.dart';

class CategoryHelper {
  static final CategoryCacheService _cacheService = CategoryCacheService();

  /// Obtiene el nombre de una categoría por su ID
  /// Utiliza el cache service para optimizar las consultas
  static Future<String> getCategoryName(String categoryId) async {
    try {
      return await _cacheService.getCategoryName(categoryId);
    } catch (e) {
      // En caso de error, retornar un valor por defecto
      return 'Sin categoría';
    }
  }

  /// Obtiene una categoría completa por su ID
  static Future<Categoria?> getCategoryById(String categoryId) async {
    try {
      return await _cacheService.getCategoryById(categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene todas las categorías
  static Future<List<Categoria>> getAllCategories() async {
    try {
      return await _cacheService.getCategories();
    } catch (e) {
      return [];
    }
  }

  /// Invalida el cache de categorías
  /// Útil cuando sabes que los datos han cambiado externamente
  static void invalidateCache() {
    _cacheService.invalidateCache();
  }
}