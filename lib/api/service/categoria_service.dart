
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/domain/category.dart';
import 'package:afranco/exceptions/api_exception.dart';

class CategoriaService {
  final CategoriaRepository _repository = CategoriaRepository();

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> getCategorias() async {
    try {
      return await _repository.getCategorias();
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
      await _repository.createCategoria(categoria);
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
      await _repository.editarCategoria(id, categoria.toJson());
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
      await _repository.eliminarCategoria(id);
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