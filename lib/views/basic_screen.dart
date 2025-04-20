import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  PantallaPrincipalState createState() => PantallaPrincipalState();
}

class PantallaPrincipalState extends State<PantallaPrincipal> {
  int _contador = 0;

  void _incrementarContador() {
    setState(() {
      _contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(20),
              child: const Text('Hola, Flutter', style: TextStyle(fontSize: 24)),
            ),
            Text(
              'Veces presionado: $_contador',
              style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _incrementarContador,
              child: const Text('Toca aquí'),
              
            ),
          ],
        ),
      ),
    );
  }
}