import 'package:flutter/material.dart';
import 'package:afranco/domain/category.dart';
Future<void> showEditCategoryDialog(BuildContext context, Category category, void Function(String nombre, String imagenUrl) onSave) async {
  final nombreController = TextEditingController(text: category.nombre);
  final imagenUrlController = TextEditingController(text: category.imagenUrl ?? '');

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar Categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imagenUrlController,
              decoration: const InputDecoration(labelText: 'URL de la imagen'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              onSave(nombreController.text, imagenUrlController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
