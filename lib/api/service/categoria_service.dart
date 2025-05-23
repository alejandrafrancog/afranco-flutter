// category_repository.dart

import 'package:dio/dio.dart';
import 'package:afranco/constants/constants.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/exceptions/api_exception.dart';
class CategoriaService {
  final Dio _dio = Dio();
  static final String _baseUrl = ApiConstants.urlCategorias;

 
    Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    late Response<dynamic> response;
    try {
       response = await _dio.post(
        ApiConstants.urlCategorias,
        data: categoria,
      );

      if (response.statusCode != 201) {
        throw ApiException(
          message:'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(message: 'Error al conectar con la API de categorías: $e', statusCode:response.statusCode);
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    late Response<dynamic> response;
    try {
      final url = '$_baseUrl/$id';
      response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        throw ApiException(
          message:'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(message:'Error al conectar con la API de categorías: $e', statusCode: response.statusCode);
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    late Response<dynamic> response;
    try {
      final url = '$_baseUrl/$id';
      response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(message: 'Error al conectar con la API de categorías: $e',statusCode: response.statusCode);
    }
  }

  Future<List<Categoria>> getCategorias() async {
    late Response<dynamic> response;
    try {
       response = await _dio.get(_baseUrl);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        List<Categoria> lista = categoriasJson.map((json) => CategoriaMapper.fromMap(json)).toList();
        for (var l in lista) {
          print(l.toString());
        }
        return lista;
      } else {
        throw ApiException(
          message: "Error ",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: "",
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
    
      throw ApiException(message:"Ayuda", statusCode:  response.statusCode);
    }
  }

    ApiException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data;
    
    String message = 'Error de conexión';
    if (errorData is Map) {
      message = errorData['message'] ?? errorData.toString();
    }
    
    return ApiException(
      message: message,
      statusCode: statusCode,
    );
  }
  
  // CRUD adicional para completar el repositorio
  Future<Categoria> createCategoria(Categoria category) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: category.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      
      if (response.statusCode == 201) {
        return CategoriaMapper.fromMap(response.data);
      }
      throw Exception('Error creando categoría: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Categoria> updateCategoria(Categoria category) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${category.id}',
        data: category.toJson(),
      );
      
      if (response.statusCode == 200) {
        return CategoriaMapper.fromMap(response.data);
      }
      throw Exception('Error actualizando categoría: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteCategoria(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');
      
      if (response.statusCode != 200) {
        throw Exception('Error eliminando categoría: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }


}
