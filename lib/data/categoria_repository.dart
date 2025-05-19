import 'package:afranco/api/service/categoria_service.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/exceptions/api_exception.dart';

class CategoriaRepository {
  final CategoriaService _service = CategoriaService();

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> getCategorias() async {
    
    try {
      List<Categoria> categorias = await _service.getCategorias();
     
      return categorias;
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      await _service.createCategoria(categoria);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Edita una categoría existente
  Future<void> editarCategoria(String id, Categoria categoria) async {
    try {
      await _service.editarCategoria(id, categoria.toMap());
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      await _service.eliminarCategoria(id);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}
