import 'package:afranco/noticias_estilos.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/categoria.dart';

Future<Map<String, dynamic>?> mostrarDialogCategoria(
  BuildContext context, {
  Categoria? categoria,
}) async {
  final TextEditingController nombreController = TextEditingController(
    text: categoria?.nombre ?? '',
  );
  final TextEditingController descripcionController = TextEditingController(
    text: categoria?.descripcion ?? '',
  );

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          categoria == null ? 'Agregar Categoría' : 'Editar Categoría',
          style: NoticiaEstilos.tituloModal,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Categoría',
              ),
            ),
            const SizedBox(height: 20.5), // Espacio entre campos
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción de la Categoría',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: NoticiaEstilos.estiloBotonPrimario(context),
            onPressed: () {
              if (nombreController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'nombre': nombreController.text,
                  'descripcion': descripcionController.text,
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('El nombre no puede estar vacío'),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}
