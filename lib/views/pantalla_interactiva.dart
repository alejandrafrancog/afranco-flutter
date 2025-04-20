import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cambio de Color',
      home: ColorChangerScreen(),
    );
  }
}

class ColorChangerScreen extends StatefulWidget {
  const ColorChangerScreen({super.key});

  @override
  ColorChangerScreenState createState() => ColorChangerScreenState();
}

class ColorChangerScreenState extends State<ColorChangerScreen> {
  // Lista de colores disponibles
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.white,
    Colors.redAccent,
    Colors.deepOrange,
    Colors.orange,
    Colors.orangeAccent,
    Colors.lime,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.brown,
    Colors.grey,
  ];
  
  int _currentColorIndex = 0;

  // Función para cambiar el color
  void _changeColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _colors.length;
    });
  }
  void _resetToWhite(){
    setState(
      (){
          _currentColorIndex = 3;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiador de Color'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container de 200x200
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: _colors[_currentColorIndex],
                borderRadius: BorderRadius.circular(10), // Bordes redondeados opcionales
              ),
              child: const Center(
                child: Text(
                  '¡Cambio de color!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Espacio entre el Container y el botón
            // Botón para cambiar el color
            ElevatedButton(
              onPressed: _changeColor,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Cambiar Color'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _resetToWhite,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Cambiar a Blanco'),
            ),
          ],
        ),
      ),
    );
  }
}