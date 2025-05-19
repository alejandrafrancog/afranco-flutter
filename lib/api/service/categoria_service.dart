import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/exceptions/api_exception.dart';
import 'package:afranco/api/service/base_service.dart';
import 'package:flutter/foundation.dart';

class CategoriaService extends BaseService {
  // URL base para las operaciones con categorías
  static final String _baseUrl = ApiConstants.urlCategorias;
  
  // Constructor
  CategoriaService() : super();

  /// Obtiene todas las categorías de la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final data = await get(_baseUrl, requireAuthToken: false);
      
      if (data is List) {
        final List<dynamic> categoriasJson = data;
        List<Categoria> lista = categoriasJson.map((json) => CategoriaMapper.fromMap(json)).toList();
        for (var l in lista) {
          debugPrint(l.toString());
        }
        return lista;
      } else {
        throw ApiException(
          message: "Error: formato de respuesta inválido",
          statusCode: 500,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: "Error al obtener categorías: $e", statusCode: 500);
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      await post(
        _baseUrl,
        data: categoria,
        requireAuthToken: true,
      );
      
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error al crear la categoría: $e', statusCode: 500);
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(String id, Map<String, dynamic> categoria) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException(message: 'ID de categoría inválido', statusCode: 400);
      }
      
      final url = '$_baseUrl/$id';
      
      await put(
        url,
        data: categoria,
        requireAuthToken: true,
      );
      
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error al editar la categoría: $e', statusCode: 500);
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException(message: 'ID de categoría inválido', statusCode: 400);
      }
      
      final url = '$_baseUrl/$id';
      
      await delete(url, requireAuthToken: true);
      
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error al eliminar la categoría: $e', statusCode: 500);
    }
  }

  /// Crea una categoría y retorna el objeto creado
  Future<Categoria> createCategoria(Categoria category) async {
    try {
      final data = await post(
        _baseUrl,
        data: category.toJson(),
        requireAuthToken: true,
      );
      
      return CategoriaMapper.fromMap(data);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error creando categoría: $e', statusCode: 500);
    }
  }

  /// Actualiza una categoría y retorna el objeto actualizado
  Future<Categoria> updateCategoria(Categoria category) async {
    try {
      // Validar que el ID no sea nulo
      if (category.id == null || category.id!.isEmpty) {
        throw ApiException(message: 'ID de categoría inválido', statusCode: 400);
      }
      
      final data = await put(
        '$_baseUrl/${category.id}',
        data: category.toJson(),
        requireAuthToken: true,
      );
      
      return CategoriaMapper.fromMap(data);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error actualizando categoría: $e', statusCode: 500);
    }
  }

  /// Elimina una categoría (método alternativo)
  Future<void> deleteCategoria(String id) async {
    try {
      await eliminarCategoria(id);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Error eliminando categoría: $e', statusCode: 500);
    }
  }
}
