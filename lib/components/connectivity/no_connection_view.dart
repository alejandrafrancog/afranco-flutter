import 'package:flutter/material.dart';

class NoConnectionView extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const NoConnectionView({
    super.key,
    required this.onRetry,
    this.message = 'Verifica tu conexión a Internet',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 100, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).primaryColor,
              ),
              foregroundColor: WidgetStatePropertyAll(
                Theme.of(context).secondaryHeaderColor,
              ),
            ),
            child: const Text('Volver atrás'),
          ),
        ],
      ),
    );
  }
}
