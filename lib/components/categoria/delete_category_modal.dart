import 'package:afranco/noticias_estilos.dart';
import 'package:flutter/material.dart';
Future<void> showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Eliminar Categoría',
           style:NoticiaEstilos.tituloModal),
        content: const Text('¿Estás segura de que querés eliminar esta categoría? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
            child: const Text('Eliminar'),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

