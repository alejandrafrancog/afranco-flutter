import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';

/// Servicio singleton para cachear categorías
class CategoryCacheService {
  // Instancia singleton private
  static final CategoryCacheService _instance =
      CategoryCacheService._internal();

  // Constructor factory que retorna la misma instancia
  factory CategoryCacheService() => _instance;
      
  // Constructor privado
  CategoryCacheService._internal();

  // Inyectamos el repositorio de categorías usando di
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  // Cache de categorías
  List<Categoria>? _categorias;

  // Timestamp de la última actualización
  DateTime? _lastRefreshed;

  // Duración del cache (opcional: para invalidación automática)
  static const Duration _cacheDuration = Duration(minutes: 10);

  /// Retorna la lista de categorías en cache
  /// Si no hay categorías en cache o están desactualizadas, realiza una carga desde la API
  Future<List<Categoria>> getCategories() async {
    try {
      // Verificar si necesitamos refrescar el cache
      if (_shouldRefreshCache()) {
        await refreshCategories();
      }
      
      // Retorna una copia de la lista para evitar modificaciones externas
      return List<Categoria>.from(_categorias ?? []);
    } catch (e) {
      debugPrint('❌ Error al obtener categorías desde cache: ${e.toString()}');
      // En caso de error, retornamos una lista vacía
      return [];
    }
  }

  /// Verifica si el cache necesita ser refrescado
  bool _shouldRefreshCache() {
    // Si no hay categorías en cache
    if (_categorias == null) return true;
    
    // Si no hay timestamp de última actualización
    if (_lastRefreshed == null) return true;
    
    // Si el cache ha expirado (opcional)
    if (DateTime.now().difference(_lastRefreshed!) > _cacheDuration) {
      debugPrint('🕐 Cache de categorías expirado, refrescando...');
      return true;
    }
    
    return false;
  }

  /// Refresca las categorías desde la API
  Future<void> refreshCategories() async {
    try {
      debugPrint('🔄 Refrescando categorías desde la API');
      _categorias = await _categoriaRepository.getCategorias();
      _lastRefreshed = DateTime.now();
      debugPrint(
        '✅ Categorías actualizadas: ${_categorias?.length ?? 0} items',
      );
    } catch (e) {
      debugPrint('❌ Error al refrescar categorías: ${e.toString()}');
      // No modificamos _categorias si hay error para mantener datos anteriores
      rethrow;
    }
  }

  /// Invalida el cache y fuerza una actualización en la próxima consulta
  /// Este método debe ser llamado cuando se crean, actualizan o eliminan categorías
  void invalidateCache() {
    debugPrint('🔄 Invalidando cache de categorías');
    _categorias = null;
    _lastRefreshed = null;
  }

  /// Actualiza el cache con una nueva lista de categorías
  /// Útil cuando ya tienes los datos actualizados y quieres evitar otra llamada a la API
  void updateCache(List<Categoria> nuevasCategorias) {
    debugPrint('📝 Actualizando cache con ${nuevasCategorias.length} categorías');
    _categorias = List<Categoria>.from(nuevasCategorias);
    _lastRefreshed = DateTime.now();
  }

  /// Verifica si las categorías están cargadas en cache
  bool get hasCachedCategories => _categorias != null;

  /// Obtiene el timestamp de la última actualización
  DateTime? get lastRefreshed => _lastRefreshed;

  /// Verifica si el cache está expirado
  bool get isCacheExpired {
    if (_lastRefreshed == null) return true;
    return DateTime.now().difference(_lastRefreshed!) > _cacheDuration;
  }

  /// Limpia la cache de categorías
  void clear() {
    _categorias = null;
    _lastRefreshed = null;
    debugPrint('🗑️ Cache de categorías limpio');
  }

  /// Obtiene una categoría específica por ID desde el cache
  /// Si no está en cache, intenta cargar todas las categorías
  Future<Categoria?> getCategoryById(String categoryId) async {
    try {
      final categorias = await getCategories();
      return categorias.firstWhere(
        (categoria) => categoria.id == categoryId,
        orElse: () => throw Exception('Categoría no encontrada'),
      );
    } catch (e) {
      debugPrint('❌ Error al obtener categoría por ID: ${e.toString()}');
      return null;
    }
  }

  /// Obtiene el nombre de una categoría por ID desde el cache
  Future<String> getCategoryName(String categoryId) async {
    try {
      final categoria = await getCategoryById(categoryId);
      return categoria?.nombre ?? 'Sin categoría';
    } catch (e) {
      debugPrint('❌ Error al obtener nombre de categoría: ${e.toString()}');
      return 'Sin categoría';
    }
  }
}