import 'package:afranco/constants/constants.dart';
import 'package:afranco/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/data/categoria_repository.dart';
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

  bool updated = false;
  Categoria? nuevaCategoria;
  final double sizedBoxHeight = 20.5;
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
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
                  SizedBox(height: sizedBoxHeight),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Ingrese una descripción'
                                : null,
                  ),
                  SizedBox(height: sizedBoxHeight),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de imagen',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: NoticiaEstilos.estiloBotonPrimario(dialogContext),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    nuevaCategoria = Categoria(
                      id: categoria.id,
                      nombre: nombreController.text,
                      descripcion: descriptionController.text,
                      imagenUrl: imagenUrlController.text,
                    );
                    updated = true;
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );

  if (updated && nuevaCategoria != null) {
    try {
      await categoriaService.editarCategoria(categoria.id!, nuevaCategoria!);
      onCategoriaActualizada();
      if (context.mounted) {
        SnackBarHelper.showSuccess(context, CategoriaConstants.successUpdated);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showClientError(
          context,
          CategoriaConstants.errorUpdated,
        );
      }
    }
  }
}
