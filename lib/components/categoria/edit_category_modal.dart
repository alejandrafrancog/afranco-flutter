import 'package:afranco/constants/constants.dart';
import 'package:afranco/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/categoria.dart';
import 'package:afranco/data/categoria_repository.dart';
import 'package:afranco/noticias_estilos.dart';

// CAMBIO PRINCIPAL: Retorna Categoria? en lugar de usar callback
Future<Categoria?> showEditCategoryDialog({
  required BuildContext context,
  required Categoria categoria,
}) async {
  final controllers = _createControllers(categoria);
  final formKey = GlobalKey<FormState>();
  final categoriaService = CategoriaRepository();

  final result = await _showEditDialog(context, controllers, formKey);
  
  if (result != null) {
    if(!context.mounted) return null;
    
    // Actualizar en la API y retornar la categoría editada
    final categoriaEditada = await _handleCategoryUpdate(
      context,
      categoriaService,
      categoria.id!,
      result,
    );
    
    _disposeControllers(controllers);
    return categoriaEditada; // Retornar la categoría editada
  }

  _disposeControllers(controllers);
  return null; // No se editó nada
}

Map<String, TextEditingController> _createControllers(Categoria categoria) {
  return {
    'nombre': TextEditingController(text: categoria.nombre),
    'descripcion': TextEditingController(text: categoria.descripcion),
    'imagenUrl': TextEditingController(text: categoria.imagenUrl),
  };
}

void _disposeControllers(Map<String, TextEditingController> controllers) {
  for (var controller in controllers.values) {
    controller.dispose();
  }
}

Future<Categoria?> _showEditDialog(
  BuildContext context,
  Map<String, TextEditingController> controllers,
  GlobalKey<FormState> formKey,
) async {
  return await showDialog<Categoria>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text(
              'Editar Categoría',
              style: NoticiaEstilos.tituloModal,
            ),
            content: _buildDialogContent(controllers, formKey),
            actions: _buildDialogActions(dialogContext, controllers, formKey),
          );
        },
      );
    },
  );
}

Widget _buildDialogContent(
  Map<String, TextEditingController> controllers,
  GlobalKey<FormState> formKey,
) {
  const double sizedBoxHeight = 20.5;
  
  return Form(
    key: formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controllers['nombre'],
          decoration: const InputDecoration(labelText: 'Nombre'),
          validator: (value) => _validateRequired(value, 'Ingrese un nombre'),
        ),
        const SizedBox(height: sizedBoxHeight),
        TextFormField(
          controller: controllers['descripcion'],
          decoration: const InputDecoration(labelText: 'Descripción'),
          validator: (value) => _validateRequired(value, 'Ingrese una descripción'),
        ),
        const SizedBox(height: sizedBoxHeight),
        TextFormField(
          controller: controllers['imagenUrl'],
          decoration: const InputDecoration(labelText: 'URL de imagen'),
        ),
      ],
    ),
  );
}

String? _validateRequired(String? value, String message) {
  return value == null || value.isEmpty ? message : null;
}

List<Widget> _buildDialogActions(
  BuildContext dialogContext,
  Map<String, TextEditingController> controllers,
  GlobalKey<FormState> formKey,
) {
  return [
    TextButton(
      onPressed: () => Navigator.of(dialogContext).pop(),
      child: const Text('Cancelar'),
    ),
    ElevatedButton(
      style: NoticiaEstilos.estiloBotonPrimario(dialogContext),
      onPressed: () => _handleSaveButton(dialogContext, controllers, formKey),
      child: const Text('Guardar'),
    ),
  ];
}

void _handleSaveButton(
  BuildContext dialogContext,
  Map<String, TextEditingController> controllers,
  GlobalKey<FormState> formKey,
) {
  if (formKey.currentState!.validate()) {
    final nuevaCategoria = _createCategoriaFromControllers(controllers);
    Navigator.of(dialogContext).pop(nuevaCategoria);
  }
}

Categoria _createCategoriaFromControllers(
  Map<String, TextEditingController> controllers,
) {
  return Categoria(
    id: null, // Se asignará el ID original en _handleCategoryUpdate
    nombre: controllers['nombre']!.text,
    descripcion: controllers['descripcion']!.text,
    imagenUrl: controllers['imagenUrl']!.text,
  );
}

// CAMBIO: Esta función ahora retorna la categoría editada
Future<Categoria?> _handleCategoryUpdate(
  BuildContext context,
  CategoriaRepository categoriaService,
  String categoriaId,
  Categoria nuevaCategoria,
) async {
  try {
    final categoriaConId = Categoria(
      id: categoriaId,
      nombre: nuevaCategoria.nombre,
      descripcion: nuevaCategoria.descripcion,
      imagenUrl: nuevaCategoria.imagenUrl,
    );
    
    await categoriaService.editarCategoria(categoriaId, categoriaConId);
    
    if (context.mounted) {
      SnackBarHelper.showSuccess(context, CategoriaConstants.successUpdated);
    }
    
    return categoriaConId; // Retornar la categoría editada
  } catch (e) {
    if (context.mounted) {
      SnackBarHelper.showClientError(
        context,
        CategoriaConstants.errorUpdated,
      );
    }
    return null; // Error al actualizar
  }
}