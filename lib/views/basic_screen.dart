import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _contador = 0;

  void _incrementarContador() {
    setState(() {
      _contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(20),
              child: Text('Hola, Flutter', style: TextStyle(fontSize: 24)),
            ),
            Text(
              'Veces presionado: $_contador',
              style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _incrementarContador,
              child: Text('Toca aquí'),
              
            ),
          ],
        ),
      ),
    );
  }
}