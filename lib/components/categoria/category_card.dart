import 'package:afranco/domain/categoria.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afranco/components/categoria/edit_category_modal.dart';

class CategoryCard extends StatelessWidget {
  final Categoria category;

  const CategoryCard({
    super.key,
    required this.category,
  });

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
            errorBuilder: (context, error, stackTrace) =>
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
              onPressed: () async {
                final categoriaEditada = await showEditCategoryDialog(
                  context: context,
                  categoria: category,
                );
                
                // Si se editó la categoría, disparar el evento de actualización
                if (categoriaEditada != null && context.mounted) {
                  context.read<CategoriaBloc>().add(
                    UpdateCategoriaEvent(categoriaEditada),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}