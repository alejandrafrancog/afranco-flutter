import 'package:afranco/core/category_cache_service.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/components/categoria/delete_category_modal.dart';
import 'package:flutter/material.dart';
import 'package:afranco/components/categoria/edit_category_modal.dart';
import 'package:watch_it/watch_it.dart';

class CategoryCard extends StatelessWidget {
  final Categoria category;
  final VoidCallback onCategoriaEliminada;
  final CategoriaRepository repository = CategoriaRepository();
  CategoryCard({
    super.key,
    required this.category,
    required this.onCategoriaEliminada,
  });

  void _eliminarCategoria(BuildContext context) async {
    try {
      await repository.eliminarCategoria(category.id!);
      await di<CategoryCacheService>().refreshCategories(); // Nuevo
      onCategoriaEliminada();

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Categoría eliminada')));
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            category.imagenUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 60),
          ),
        ),
        title: Text(
          category.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(category.descripcion),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showEditCategoryDialog(
                  context: context,
                  categoria: category,
                  onCategoriaActualizada: onCategoriaEliminada,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeleteConfirmationDialog(context, () {
                  _eliminarCategoria(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
