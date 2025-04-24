// category_service.dart
import 'package:afranco/domain/category.dart';
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

