import 'package:afranco/domain/categoria.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/components/delete_category_modal.dart';
import 'package:flutter/material.dart';
import 'package:afranco/components/edit_category_modal.dart';

class CategoryCard extends StatelessWidget {
  final Categoria category;
  final VoidCallback onCategoriaEliminada;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onCategoriaEliminada,
  });

  void _eliminarCategoria(BuildContext context) async {
    final categoriaService = CategoriaRepository();
    try {
      await categoriaService.eliminarCategoria(category.id!);
      onCategoriaEliminada(); // Refrescar la lista

      // Verificamos si el widget aún está montado antes de usar el contexto
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
        subtitle: Text('ID: ${category.id ?? 'N/A'}'),
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
