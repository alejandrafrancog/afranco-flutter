// category_service.dart
/*import 'package:afranco/domain/category.dart';
import 'package:afranco/data/categoria_repository.dart';

class CategoryService {
  final CategoryRepository _repository = CategoryRepository();


  Future<List<Category>> fetchAllCategories() async {
    try {
      return await _repository.getCategorias();
    } catch (e) {
      throw Exception('No se pudieron obtener las categorías: ${e.toString()}');
    }
  }

  Future<Category> createNewCategory(Category category) async {
    try {
      return await _repository.createCategory(category);
    } catch (e) {
      throw Exception('No se pudo crear la categoría: ${e.toString()}');
    }
  }

  Future<Category> modifyCategory(Category category) async {
    try {
      return await _repository.updateCategory(category);
    } catch (e) {
      throw Exception('No se pudo actualizar la categoría: ${e.toString()}');
    }
  }

  Future<void> removeCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
    } catch (e) {
      throw Exception('No se pudo eliminar la categoría: ${e.toString()}');
    }
  }
}
*/
/*
import 'package:dio/dio.dart';
import 'package:afranco/constants.dart';
import 'package:afranco/domain/category.dart';
import 'package:afranco/exceptions/api_exception.dart';

class CategoriaRepository {
  final Dio _dio = Dio();

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get("${ApiConstants.crudApiUrl}${ApiConstants.categoryEndpoint}");

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw ApiException(
          message:'Error al obtener las categorías',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de categorías: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        Constantes.urlCategorias,
        data: categoria,
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      final url = '${Constantes.urlCategorias}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${Constantes.urlCategorias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }
}
*/
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