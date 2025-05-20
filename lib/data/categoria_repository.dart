import 'package:afranco/api/service/categoria_service.dart';
import 'package:afranco/data/base_repository.dart';
import 'package:afranco/domain/categoria.dart';

class CategoriaRepository extends BaseRepository {
  final CategoriaService _service = CategoriaService();

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> getCategorias() async {
    return handleApiCall(() async {
      final categorias = await _service.getCategorias();
      return categorias;
    });
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    checkForEmpty([
      MapEntry('nombre', categoria.nombre),
      MapEntry('descripción', categoria.descripcion),
    ]);

    await handleApiCall(() => _service.createCategoria(categoria));
  }

  /// Edita una categoría existente
  Future<void> editarCategoria(String id, Categoria categoria) async {
    checkForEmpty([
      MapEntry('ID', id),
      MapEntry('nombre', categoria.nombre),
      MapEntry('descripción', categoria.descripcion),
    ]);

    await handleApiCall(() => _service.editarCategoria(id, categoria.toMap()));
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    checkForEmpty([MapEntry('ID', id)]);

    await handleApiCall(() => _service.eliminarCategoria(id));
  }
}
