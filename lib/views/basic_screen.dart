import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text('Hola, Flutter', style: TextStyle(fontSize: 24)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Presionar'),
          ),
        ],
      ),
    );
  }
}
