import 'package:afranco/core/category_cache_service.dart';
import 'package:afranco/domain/categoria.dart';

class CategoryHelper {
  static final CategoryCacheService _cacheService = CategoryCacheService();

  static Future<String> getCategoryName(String categoryId) async {
    try {
      return await _cacheService.getCategoryName(categoryId);
    } catch (e) {
      // En caso de error, retornar un valor por defecto
      return 'Sin categoría';
    }
  }

  static Future<Categoria?> getCategoryById(String categoryId) async {
    try {
      return await _cacheService.getCategoryById(categoryId);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Categoria>> getAllCategories() async {
    try {
      return await _cacheService.getCategories();
    } catch (e) {
      return [];
    }
  }


  static void invalidateCache() {
    _cacheService.invalidateCache();
  }
}