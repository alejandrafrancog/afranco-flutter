import 'package:flutter/material.dart';
import 'package:afranco/domain/category.dart';
import 'package:afranco/api/service/categoria_repository.dart';
import 'package:afranco/noticias_estilos.dart';

Future<void> showEditCategoryDialog({
  required BuildContext context,
  required Categoria categoria,
  required VoidCallback onCategoriaActualizada,
}) async {
  final TextEditingController nombreController = TextEditingController(
    text: categoria.nombre,
  );
  final TextEditingController descriptionController = TextEditingController(
    text: categoria.descripcion,
  );
  final TextEditingController imagenUrlController = TextEditingController(
    text: categoria.imagenUrl,
  );

  final formKey = GlobalKey<FormState>();
  final categoriaService = CategoriaRepository();

  await showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text(
            'Editar Categoría',
            style: NoticiaEstilos.tituloModal,
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Ingrese un nombre'
                              : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Ingrese un nombre'
                              : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de imagen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: NoticiaEstilos.estiloBotonPrimario(context),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final nuevaCategoria = Categoria(
                    id: categoria.id,
                    nombre: nombreController.text,
                    descripcion: descriptionController.text,
                    imagenUrl: imagenUrlController.text,
                  );

                  try {
                    await categoriaService.editarCategoria(
                      categoria.id!,
                      nuevaCategoria,
                    );
                    onCategoriaActualizada();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Categoría actualizada')),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar: $e')),
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
  );
}
