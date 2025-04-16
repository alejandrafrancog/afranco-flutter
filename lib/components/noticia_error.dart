import 'package:flutter/material.dart';
import '../noticias_estilos.dart';
class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorMessage({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message', style: NoticiaEstilos.mensajeError),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
