import 'package:flutter/material.dart';
import 'views/login_screen.dart'; // Mantén esta línea y elimina la duplicada
import 'constants.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary:  Colors.teal,
          secondary: Colors.tealAccent,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  String _getCounterMessage() {
    if (_counter > 0) {
      return 'Contador en positivo';
    } else if (_counter < 0) {
      return 'Contador en negativo';
    } else {
      return 'Contador en cero';
    }
  }

  Color _getCounterColor() {
    if (_counter > 0) {
      return Colors.green;
    } else if (_counter < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            //const Text('Hola soy Ale F'),
            // Nuevo widget Text que muestra el estado del contador
            Text(
              _getCounterMessage(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getCounterColor(),
              ),
            ),
            ElevatedButton(
              style:AppStyles.elevatedButtonStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Advertencia'),
                      content: const Text(
                        'Esta es una advertencia importante.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Mostrar Advertencia'),
            ),
            SizedBox(height: 20),
        ElevatedButton(
              style:AppStyles.elevatedButtonStyle,
                onPressed: () {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  } catch (e) {
                    // Maneja el error aquí, por ejemplo, mostrando un mensaje en la consola
                    print('Error al navegar a LoginScreen: $e');
                    // Opcional: Muestra un SnackBar con el error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: No se pudo abrir la pantalla de login')),
                    );
                  }
                },
              child: const Text('Login'),
      ),
          ],
        ),
      ),
floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      heroTag: 'incrementButton', // Unique tag
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
    const SizedBox(width: 16),
    FloatingActionButton(
      heroTag: 'decrementButton', // Unique tag
      onPressed: _decrementCounter,
      tooltip: 'Decrement',
      child: const Icon(Icons.remove),
    ),
    const SizedBox(width: 16),
    FloatingActionButton(
      heroTag: 'resetButton', // Unique tag
      onPressed: _resetCounter,
      tooltip: 'Reset',
      child: const Icon(Icons.refresh),
    ),
  ],
),
    );
  }
}
