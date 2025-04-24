// category_repository.dart
import 'package:dio/dio.dart';
import 'package:afranco/constants.dart';
import 'package:afranco/domain/category.dart';

class CategoryRepository {
  final Dio _dio = Dio();
  static String _baseUrl = 
      '${ApiConstants.crudApiUrl}${ApiConstants.categoryEndpoint}';

  Future<List<Category>> getCategorias() async {
    try {
      final response = await _dio.get(_baseUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Category.fromJson(json)).toList();
      }
      throw Exception('Error al obtener categorías: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  // CRUD adicional para completar el repositorio
  Future<Category> createCategory(Category category) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: category.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      
      if (response.statusCode == 201) {
        return Category.fromJson(response.data);
      }
      throw Exception('Error creando categoría: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Category> updateCategory(Category category) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${category.id}',
        data: category.toJson(),
      );
      
      if (response.statusCode == 200) {
        return Category.fromJson(response.data);
      }
      throw Exception('Error actualizando categoría: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final response = await _dio.delete('${_baseUrl}${ApiConstants.categoryEndpoint}$id');
      
      if (response.statusCode != 200) {
        throw Exception('Error eliminando categoría: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final errorData = e.response!.data;
      final mensaje = errorData is Map 
          ? errorData['message'] ?? errorData.toString()
          : errorData.toString();
      
      return Exception('Error de servidor: $mensaje');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
