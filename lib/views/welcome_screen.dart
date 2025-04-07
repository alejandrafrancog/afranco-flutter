import 'package:flutter/material.dart';
import 'package:afranco/views/tasks.dart'; // Mantén esta línea y elimina la duplicada

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        automaticallyImplyLeading: false, // Oculta el botón de retroceso
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            Text(
              '¡Bienvenido!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Has iniciado sesión exitosamente',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksScreen(), // Asegúrate de crear esta pantalla
                  ),
                );
                // Aquí puedes agregar la navegación a la pantalla de cotizaciones
                // Por ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => QuotesScreen()));
              },
              child: const Text('Lista de Tareas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Cierra todas las pantallas y vuelve al inicio
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
